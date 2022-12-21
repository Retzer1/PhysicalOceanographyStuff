function output = avgDivStore(struc) %output records COM positions for each triangle, along with their divergence estimate at that point. Otherwise, triangle selection process is same as avgDiv, see comments in that function for more info.  

%Have an option to input your own datenums, in case you want to use one
%that encompasses for both structures.
datenums = find_datenum(struc)';
lenDate = length(datenums);
output = []; 
counter = 0;
for i = 1:lenDate %Loop over datenums
    if i == 4208
        abc = 1;
    end
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
        if Lambda <= 0.2
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
        triangles = cat(2, triangles, divergences); %triangles(:, 7) is divergences 
        triangles = cat(2, triangles, zeros(triLength, 1)); %triangles(:, 8) is mean lat
        triangles = cat(2, triangles, zeros(triLength, 1)); %triangles(:, 9) is mean lon
        
        %CALCULATE MEAN/CENTER OF MASS POSITIONS
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
        
        triangles(j, 9) = (lon1 + lon2 + lon3)/3;
        triangles(j, 8) = (lat1 + lat2 + lat3)/3;
    end
        toOutput = [triangles(:, 8) triangles(:, 9) triangles(:, 7)]; %COM LAT, COM LON, DIV
        output = cat(1, output, toOutput);
end
end