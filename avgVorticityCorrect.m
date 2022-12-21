function [output, numTriangles] = avgVorticityCorrect(struc, errorQ, meanFlag) %output is a vector of length as many time steps as we have. 
%At present, we only make sure a triangle is not deformed at its time step, Also, we assume all drifters
%have same times as each other, they are on same schedule, example: we
%dont't have one at 12:07, 12:12, etc and another at 12:10, 12:15, etc, and all intervals are 5 mins. 
newStruc = add_uv(struc); 
%For a given drifter i and time step, uf/vf is u(i)(k)/v(i)(k). 
%For a given drifter i and time step, ub/vb is u(i)(k-1)/v(i)(k-1)
%Have an option to input your own datenums, in case you want to use one
%that encompasses for both structures.
datenums = find_datenum(newStruc)';
lenDate = length(datenums);
output = zeros(lenDate, 1); %This will store mean divergence for each datenum
counter = 0;
numTriangles = zeros(lenDate, 1); %Count the number of triangles for debugging purposes 

for i = 1:lenDate %Loop over datenums
    
    latLonMat = latLonIndexRowVorticity(newStruc, datenums(i));
    latLon = latLonMat(:, [1 2]); %COL 1 is v, COL 2 is u
    
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
        L = Lambda1(s1, s2, s3);
        if L <= errorQ || Area < 0.1
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
            
            vf1 = newStruc(drifterNum1).v(index1);
            vf2 = newStruc(drifterNum2).v(index2);
            vf3 = newStruc(drifterNum3).v(index3);
            
            uf1 = newStruc(drifterNum1).u(index1);
            uf2 = newStruc(drifterNum2).u(index2);
            uf3 = newStruc(drifterNum3).u(index3);
            
            %LAT/LON Of POINT 1
            lat1 = latLonMat(row1, 1); 
            lon1 = latLonMat(row1, 2);
            
            %Transformed LAT/LON of NEXT point 1
            [latNext1, lonNext1] = findNewPosition([lat1 lon1], [-0.300*uf1 0.300*vf1]);
            
            
            %LAT/LON Of POINT 2
            lat2 = latLonMat(row2, 1);
            lon2 = latLonMat(row2, 2);

            %Transformed LAT/LON of NEXT point 2
            [latNext2, lonNext2] = findNewPosition([lat2 lon2], [-0.3*uf2 0.3*vf2]); 
            
            %LAT/LON Of POINT 3
            lat3 = latLonMat(row3, 1);
            lon3 = latLonMat(row3, 2);
            
            %Transformed LAT/LON of NEXT point 3
            [latNext3, lonNext3] = findNewPosition([lat3 lon3], [-0.3*uf3 0.3*vf3]); 
            

            %SIDE LENGTHS
            s1 = geo_distance_COOK(lonNext1, latNext1, lonNext2, latNext2);
            s2 = geo_distance_COOK(lonNext2, latNext2, lonNext3, latNext3);
            s3 = geo_distance_COOK(lonNext3, latNext3, lonNext1, latNext1);

            %AREA
            semiPeri = (s1 + s2 + s3)/2; %Semi-Perimeter
            nextArea = sqrt(semiPeri*(semiPeri-s1)*(semiPeri-s2)*(semiPeri-s3));
            triangles(j, 5) = nextArea;

            %DEFORMATION CHECK----NOt currently necessary for next areas
            L = Lambda1(s1, s2, s3);
            if L <= errorQ || Area < 0.1
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

                vb1 = newStruc(drifterNum1).v(index1-1);
                vb2 = newStruc(drifterNum2).v(index2-1);
                vb3 = newStruc(drifterNum3).v(index3-1);
            
                ub1 = newStruc(drifterNum1).u(index1-1);
                ub2 = newStruc(drifterNum2).u(index2-1);
                ub3 = newStruc(drifterNum3).u(index3-1);
            
                %LAT/LON Of POINT 1
                lat1 = latLonMat(row1, 1); 
                lon1 = latLonMat(row1, 2);

                %Transformed LAT/LON of NEXT point 1
                [latPrev1, lonPrev1] = findNewPosition([lat1 lon1], [0.300*ub1 -0.300*vb1]);


                %LAT/LON Of POINT 2
                lat2 = latLonMat(row2, 1);
                lon2 = latLonMat(row2, 2);

                %Transformed LAT/LON of NEXT point 2
                [latPrev2, lonPrev2] = findNewPosition([lat2 lon2], [0.300*ub2 -0.300*vb2]); 

                %LAT/LON Of POINT 3
                lat3 = latLonMat(row3, 1);
                lon3 = latLonMat(row3, 2);

                %Transformed LAT/LON of NEXT point 3
                [latPrev3, lonPrev3] = findNewPosition([lat3 lon3], [0.300*ub3 -0.300*vb3]); 
                
                %SIDE LENGTHS
                s1 = geo_distance_COOK(lonPrev1, latPrev1, lonPrev2, latPrev2);
                s2 = geo_distance_COOK(lonPrev2, latPrev2, lonPrev3, latPrev3);
                s3 = geo_distance_COOK(lonPrev3, latPrev3, lonPrev1, latPrev1);
    
                %AREA
                semiPeri = (s1 + s2 + s3)/2; %Semi-Perimeter
                prevArea = sqrt(semiPeri*(semiPeri-s1)*(semiPeri-s2)*(semiPeri-s3));
                triangles(j, 6) = prevArea;

                %DEFORMATION CHECK----NOt currently necessary for next areas
                L = Lambda1(s1, s2, s3);
                %Lambda = 12*sqrt(3)*prevArea/((2*semiPeri)^2);
                if L <= errorQ || Area < 0.1
                    errorIndicesPrev = [errorIndicesPrev j];
                end

            end
            %DEFORMATION ERROR REMOVALS
            triangles(errorIndicesPrev, :) = [];
            triLength = size(triangles, 1); %Redo triLength now that we've removed some things
            %CALCULATE PREV AREAS   
            if triLength ~= 0 %If this passes, then you have prev, next, and cur triangles not deformed. 
                %CALCULATE 'DIVERGENCES' (really vorticity)
                areaDiff = triangles(:, 5) - triangles(:, 6); %This is in square km, nextAreas - prevAreas
                areaDiff = areaDiff./triangles(:, 4); %Fractional difference
                divergences = areaDiff/600; %We now have our area rate of change, in terms of % change per second, as we divided by time here ( 2*delta time)
                
                %FIND COM LAT
                triangles = cat(2, triangles, zeros(triLength, 1));
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
                    actualLat1 = struc(drifterNum1).lat(index1); 
                    

                    %LAT/LON Of POINT 2
                    actualLat2 = struc(drifterNum2).lat(index2);
                   

                    %LAT/LON Of POINT 3
                    actualLat3 = struc(drifterNum3).lat(index3);
                    
                    meanLat = (actualLat1 + actualLat2 + actualLat3)/3;
                    triangles(j, 7) = meanLat; %COM lat
                end
                %NORMALIZE WITH CORIOLIS
                for j = 1:length(divergences)
                    divergences(j) = divergences(j)/coriolis(triangles(j, 7));
                end
              
                if meanFlag == 'medi'
                    %CALCULATE MEAN DIVERGENCE
                    output(i, 1) = median(divergences); 
                    numTriangles(i, 1) = triLength;
                elseif meanFlag == 'mean'
                    %CALCULATE MEDIAN DIVERGENCE
                    output(i, 1) = mean(divergences);
                    numTriangles(i, 1) = triLength;
                end
            else %No triangles remaining at this timestep after quality control
                output(i, 1) = NaN;
                numTriangles(i, 1) = triLength;
            end
        else %No triangles remaining at this timestep after quality control
            output(i, 1) = NaN;
            numTriangles(i, 1) = triLength;
        end
    else %No triangles remaining at this timestep after quality control
        output(i, 1) = NaN;
        numTriangles(i, 1) = triLength;
    end
    
end

end
function output2 = Lambda1(s11, s22, s33)
    semiPerimeter = (s11 + s22 + s33)/2;
    area = sqrt(semiPerimeter*(semiPerimeter-s11)*(semiPerimeter-s22)*(semiPerimeter-s33));
    
    output2 = 12*sqrt(3)*area/((2*semiPerimeter)^2);
end
%TRIANGLES:
%PT1, PT2, PT3, AREA, NEXT AREA, PREV AREA, DIV