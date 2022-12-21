function output = avgDivAnimate(struc, errorQ) %output is a vector of length as many time steps as we have. 
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
output = zeros(lenDate, 1); %This will store mean divergence for each datenum
counter = 0;
for i = 1:lenDate %Loop over datenums
   
    latLonMat = latLonIndexRow(struc, datenums(i));
    latLon = latLonMat(:, [1 2]);
    
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
        Lambda = 12*sqrt(3)*Area/((2*semiPeri)^2);
        if Lambda <= errorQ
            errorIndices = [errorIndices j];
        end
    end
    
    %DEFORMATION ERROR REMOVALS
    triangles(errorIndices, :) = [];
    triLength = size(triangles, 1); %Redo triLength now that we've removed some things
    
    
    %CALCULATE NEXT AREAS
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
        %Lambda = 12*sqrt(3)*nextArea/((2*semiPeri)^2);
        %if Lambda <= 0.2
        %    errorIndices = [errorIndices j];
        %end
        
    end
        
    %CALCULATE PREV AREAS
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
        %Lambda = 12*sqrt(3)*nextArea/((2*semiPeri)^2);
        %if Lambda <= 0.2
        %    errorIndices = [errorIndices j];
        %end
        
    end

        %CALCULATE DIVERGENCES
        areaDiff = triangles(:, 6) - triangles(:, 4); %This is in square km
        areaDiff = areaDiff./triangles(:, 5); %Fractional difference
        divergences = areaDiff/600; %We now have our area rate of change, in terms of % change per second, as we divided by time here ( 2*delta time)
        if i == 1619
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
        output(i, 1) = mean(divergences); 
    
    
end
end