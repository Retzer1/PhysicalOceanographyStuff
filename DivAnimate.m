function [numTriangles] = DivAnimate(struc, errorQ, fps, filename) %output is a vector of length as many time steps as we have. 
%At present, we only make sure a triangle is not deformed at its time step,
%its okay if it becomes too deformed at the next time step or if it was too
%deformed at the previous time step as long as it is not too deformed at
%the current time step. We may change this. Also, we assume all drifters
%have same times as each other, they are on same schedule, example: we
%dont't have one at 12:07, 12:12, etc and another at 12:10, 12:15, etc, and all intervals are 5 mins. 

%Have an option to input your own datenums, in case you want to use one
%that encompasses for both structures.
datenums = find_datenum(struc)';
lenDate = length(datenums);
counter = 0;
numTriangles = zeros(lenDate, 1); %Count the number of triangles for debugging purposes 
latLonPlural = NaN(9, 2, lenDate); %Want to accomodate for 100 triangles max at any time. 2 cols, lenDate pages, 100 rows
Triangles = NaN(100, 3, lenDate);
Colors = NaN(100, 3, lenDate);
DIVS = NaN(100, 1, lenDate);
%V will come from Colors

for i = 1:lenDate %Loop over datenums
   
    latLonMat = latLonIndexRow(struc, datenums(i));
    latLon = latLonMat(:, [1 2]);
    lenLatLon = size(latLon, 1);
    latLonPlural(1:lenLatLon, 1:2, i) = latLon;
    
    if size(latLonMat, 1) < 3 || nnz(latLon(:, 1)) < 3 %If we have less than 3 drifters present, don't attempt any triangulation
        counter = counter + 1;
        continue
    end
    triangles = delaunay(latLon); %This is our triangulation for this time.
    triLength = size(triangles, 1);
    
    
    
    triangles = cat(2, triangles, zeros(triLength, 1)); %Add a column for the current areas
    
    %CALCULATE CURRENT AREAS, DEFORMATION ERROR CHECK---------------------
    errorIndices = [];
    for j = 1:triLength
        row1 = triangles(j, 1); %This is the row number in latLonMat for the 1st point of this triangle
        row2 = triangles(j, 2); %Row number in latLonMat for 2nd point of this triangle
        row3 = triangles(j, 3); %Row number in latLonMat for 3rd point of this triangle

        drifterNum1 = latLonMat(row1, 4);
        drifterNum2 = latLonMat(row2, 4);
        drifterNum3 = latLonMat(row3, 4);
        
        index1 = latLonMat(row1, 3);
        index2 = latLonMat(row2, 3);
        index3 = latLonMat(row3, 3);
        
        %LAT/LON Of POINT 1
        lat1 = latLonMat(row1, 1); 
        lon1 = latLonMat(row1, 2);
    
        %LAT/LON Of POINT 2
        lat2 = latLonMat(row2, 1);
        lon2 = latLonMat(row2, 2);
        
        %LAT/LON Of POINT 3
        lat3 = latLonMat(row3, 1);
        lon3 = latLonMat(row3, 2);
        
        %SIDE LENGTHS
        s1 = geo_distance_COOK(lon1, lat1, lon2, lat2);
        s2 = geo_distance_COOK(lon2, lat2, lon3, lat3);
        s3 = geo_distance_COOK(lon3, lat3, lon1, lat1);
        
        
        %AREA
        semiPeri = (s1 + s2 + s3)/2; %Semi-Perimeter
        Area = sqrt(semiPeri*(semiPeri-s1)*(semiPeri-s2)*(semiPeri-s3));
        triangles(j, 4) = Area;
        
        %DEFORMATION CHECK
        L = Lambda(struc, drifterNum1, drifterNum2, drifterNum3, index1, index2, index3);
        if L <= errorQ
            errorIndices = [errorIndices j];
        end
    end
    
    %DEFORMATION ERROR REMOVALS
    triangles(errorIndices, :) = [];
    triLength = size(triangles, 1); %Redo triLength now that we've removed some things
    
    if triLength ~= 0
        %CALCULATE NEXT AREAS
        errorIndicesNext = [];
        triangles = cat(2, triangles, zeros(triLength, 1)); %Add column 5, for next areas. 
        for j = 1:triLength
            row1 = triangles(j, 1); %This is the row number in latLonMat for the 1st point of this triangle
            row2 = triangles(j, 2); %Row number in latLonMat for 2nd point of this triangle
            row3 = triangles(j, 3); %Row number in latLonMat for 3rd point of this triangle

            drifterNum1 = latLonMat(row1, 4);
            drifterNum2 = latLonMat(row2, 4);
            drifterNum3 = latLonMat(row3, 4);

            index1 = latLonMat(row1, 3);
            index2 = latLonMat(row2, 3);
            index3 = latLonMat(row3, 3);

            s1 = geo_distance_COOK(struc(drifterNum1).lon(index1+1), struc(drifterNum1).lat(index1+1), struc(drifterNum2).lon(index2+1), struc(drifterNum2).lat(index2+1)); 
            s2 = geo_distance_COOK(struc(drifterNum2).lon(index2+1), struc(drifterNum2).lat(index2+1), struc(drifterNum3).lon(index3+1), struc(drifterNum3).lat(index3+1)); 
            s3 = geo_distance_COOK(struc(drifterNum3).lon(index3+1), struc(drifterNum3).lat(index3+1), struc(drifterNum1).lon(index1+1), struc(drifterNum1).lat(index1+1)); 

            %AREA
            semiPeri = (s1 + s2 + s3)/2; %Semi-Perimeter
            nextArea = sqrt(semiPeri*(semiPeri-s1)*(semiPeri-s2)*(semiPeri-s3));
            triangles(j, 5) = nextArea;

            %DEFORMATION CHECK----NOt currently necessary for next areas
            L = Lambda(struc, drifterNum1, drifterNum2, drifterNum3, index1+1, index2+1, index3+1);
            if L <= errorQ
                errorIndicesNext = [errorIndicesNext j];
            end

        end
        %DEFORMATION ERROR REMOVALS
        triangles(errorIndicesNext, :) = [];
        triLength = size(triangles, 1); %Redo triLength now that we've removed some things
        if triLength ~= 0
            %CALCULATE PREV AREAS
            errorIndicesPrev = [];
            triangles = cat(2, triangles, zeros(triLength, 1)); %Add column 6, for prev areas. 
            for j = 1:triLength
                row1 = triangles(j, 1); %This is the row number in latLonMat for the 1st point of this triangle
                row2 = triangles(j, 2); %Row number in latLonMat for 2nd point of this triangle
                row3 = triangles(j, 3); %Row number in latLonMat for 3rd point of this triangle

                drifterNum1 = latLonMat(row1, 4);
                drifterNum2 = latLonMat(row2, 4);
                drifterNum3 = latLonMat(row3, 4);

                index1 = latLonMat(row1, 3);
                index2 = latLonMat(row2, 3);
                index3 = latLonMat(row3, 3);

                s1 = geo_distance_COOK(struc(drifterNum1).lon(index1-1), struc(drifterNum1).lat(index1-1), struc(drifterNum2).lon(index2-1), struc(drifterNum2).lat(index2-1)); 
                s2 = geo_distance_COOK(struc(drifterNum2).lon(index2-1), struc(drifterNum2).lat(index2-1), struc(drifterNum3).lon(index3-1), struc(drifterNum3).lat(index3-1)); 
                s3 = geo_distance_COOK(struc(drifterNum3).lon(index3-1), struc(drifterNum3).lat(index3-1), struc(drifterNum1).lon(index1-1), struc(drifterNum1).lat(index1-1)); 

                %AREA
                semiPeri = (s1 + s2 + s3)/2; %Semi-Perimeter
                prevArea = sqrt(semiPeri*(semiPeri-s1)*(semiPeri-s2)*(semiPeri-s3));
                triangles(j, 6) = prevArea;

                %DEFORMATION CHECK----NOt currently necessary for next areas
                L = Lambda(struc, drifterNum1, drifterNum2, drifterNum3, index1-1, index2-1, index3-1);
                %Lambda = 12*sqrt(3)*prevArea/((2*semiPeri)^2);
                if L <= errorQ
                    errorIndicesPrev = [errorIndicesPrev j];
                end

            end
            %DEFORMATION ERROR REMOVALS
            triangles(errorIndicesPrev, :) = [];
            triLength = size(triangles, 1); %Redo triLength now that we've removed some things
            %CALCULATE PREV AREAS   
            if triLength ~= 0 %If this passes, then you have prev, next, and cur triangles not deformed. 
                %CALCULATE DIVERGENCES
                areaDiff = triangles(:, 5) - triangles(:, 6); %This is in square km, nextAreas - prevAreas
                areaDiff = areaDiff./triangles(:, 4); %Fractional difference
                divergences = areaDiff/600; %We now have our area rate of change, in terms of % change per second, as we divided by time here ( 2*delta time)
                DIVS(1:triLength, 1, i) = divergences; %Store divergences for this datenum, rows linked to triangles
                Triangles(1:triLength, 1:3, i) = triangles(:, 1:3); %Store triangles for this datenum
                if i == 1973
                    abc = 1;
                end
        %         %FIND COM LAT
        %         leng = length(divergences);
        %         meanLat = zeros(leng, 1); 
        %         
        %         %NORMALIZE WITH CORIOLIS
        %         for k = 1:length(divergences)
        %             divergences(k) = divergences(k)/coriolis(meanLat(k));
        %         end

                %CALCULATE MEAN DIVERGENCE
                
                numTriangles(i, 1) = triLength;
                
            else
                
                numTriangles(i, 1) = triLength;
            end
        else
            
            numTriangles(i, 1) = triLength;
        end
    else
        
        numTriangles(i, 1) = triLength;
    end
    
end
rngArray = range(DIVS);
%FIND COLORS CORRESPONDING TO TRIANGLES
for i = 1:lenDate
    if numTriangles(i, 1) ~= 0 %OTherwise skip and leave it as sheet of nans
        for j = 1:numTriangles(i, 1)
            Colors(j, 1:3, i) = equiv_color(DIVS(j, 1, i), rngArray);
        end
    end
end
%DONE WITH COLORS, AND ALL OTHER MATRICES, BEGIN ANIMATING
FrameNumber = nnz(numTriangles(:, 1));
curFrame = 0;
indexes = find(numTriangles(:, 1) ~= 0);

for i = 1:length(indexes) %Loop over datenums that do, in fact, have at least 1 triangle
    %i
    numberTriangles = numTriangles(indexes(i), 1);
    %if numberTriangles ~= 0
    curFrame = curFrame + 1;
    plot_tri_cols2(Triangles(1:numberTriangles,1:3, indexes(i)), latLonPlural(:, [2 1], indexes(i)), Colors(1:numberTriangles,1:3, indexes(i)), rngArray)
    save_frame(curFrame,FrameNumber, fps, filename);
   % end

end
end


function output2 = Lambda(struc, drifter1, drifter2, drifter3, i1, i2, i3)
    
    s11 = geo_distance_COOK(struc(drifter1).lon(i1), struc(drifter1).lat(i1), struc(drifter2).lon(i2), struc(drifter2).lat(i2)); 
    s22 = geo_distance_COOK(struc(drifter2).lon(i2), struc(drifter2).lat(i2), struc(drifter3).lon(i3), struc(drifter3).lat(i3)); 
    s33 = geo_distance_COOK(struc(drifter3).lon(i3), struc(drifter3).lat(i3), struc(drifter1).lon(i1), struc(drifter1).lat(i1));  
    semiPerimeter = (s11 + s22 + s33)/2;
    area = sqrt(semiPerimeter*(semiPerimeter-s11)*(semiPerimeter-s22)*(semiPerimeter-s33));
    
    output2 = 12*sqrt(3)*area/((2*semiPerimeter)^2);
end
%TRIANGLES:
%PT1, PT2, PT3, AREA, NEXT AREA, PREV AREA, DIV