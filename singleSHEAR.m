function [datenums, output] = singleSHEAR(struc, drifterNum1, drifterNum2, drifterNum3, errorQ)
    datenums = find_datenum(struc);
    lenDate = length(datenums);
    output = NaN(lenDate, 1); %This will store shear deformation for each datenum for our triangle
    newStruc = struc;
    for i = 1:lenDate %Loop over datenums
        
        index1 = whichdatenum(struc, drifterNum1, datenums(i));
        index2 = whichdatenum(struc, drifterNum2, datenums(i));
        index3 = whichdatenum(struc, drifterNum3, datenums(i));
        
        len1 = length(struc(drifterNum1).datenum);
        len2 = length(struc(drifterNum2).datenum);
        len3 = length(struc(drifterNum3).datenum);
        
        if any([index1 index2 index3] < 2, 'all') || index1 == len1 || index2 == len2 || index3 == len3 %Ensure that for all three drifters, this is not the last, nor first, entry, and that all are indeed present
            continue
        end
        
        %LAT/LON Of POINT 1
        lat1 = struc(drifterNum1).lat(index1); 
        lon1 = struc(drifterNum1).lon(index1);
    
        %LAT/LON Of POINT 2
        lat2 = struc(drifterNum2).lat(index2); 
        lon2 = struc(drifterNum2).lon(index2);
        
        %LAT/LON Of POINT 3
        lat3 = struc(drifterNum3).lat(index3); 
        lon3 = struc(drifterNum3).lon(index3);
        
        %SIDE LENGTHS
        s1 = geo_distance_COOK(lon1, lat1, lon2, lat2);
        s2 = geo_distance_COOK(lon2, lat2, lon3, lat3);
        s3 = geo_distance_COOK(lon3, lat3, lon1, lat1);
        
        
        %AREA
        semiPeri = (s1 + s2 + s3)/2; %Semi-Perimeter
        Area = sqrt(semiPeri*(semiPeri-s1)*(semiPeri-s2)*(semiPeri-s3));
      
        
        %DEFORMATION CHECK
        L = Lambda1(s1, s2, s3);
        if L <= errorQ || Area < 0.1
            continue
        end
    
        %CALCULATE NEXT AREAS
        
        %VELOCITY COMPONENT ESTIMATES--------------------
        vf1 = (newStruc(drifterNum1).lat(index1+1) - newStruc(drifterNum1).lat(index1))/300;
        vf2 = (newStruc(drifterNum2).lat(index2+1) - newStruc(drifterNum2).lat(index2))/300;
        vf3 = (newStruc(drifterNum3).lat(index3+1) - newStruc(drifterNum3).lat(index3))/300;      

        uf1 = (newStruc(drifterNum1).lon(index1+1) - newStruc(drifterNum1).lon(index1))/300;
        uf2 = (newStruc(drifterNum2).lon(index2+1) - newStruc(drifterNum2).lon(index2))/300;
        uf3 = (newStruc(drifterNum3).lon(index3+1) - newStruc(drifterNum3).lon(index3))/300;
        %VELOCITY COMPONENT ESTIMATES--------------------
        
        
        
        %TRANSFORMATIONS--------------------------------------

        %Transformed LAT/LON of NEXT point 1

        latNext1 = lat1 + 300*uf1;
        lonNext1 = lon1 + 300*vf1;

        %Transformed LAT/LON of NEXT point 2

        latNext2 = lat2 + 300*uf2;
        lonNext2 = lon2 + 300*vf2;

        %Transformed LAT/LON of NEXT point 3

        latNext3 = lat3 + 300*uf3;
        lonNext3 = lon3 + 300*vf3;


        %TRANSFORMATIONS ^^^------------------------------------

        %SIDE LENGTHS
        s1 = geo_distance_COOK(lonNext1, latNext1, lonNext2, latNext2);
        s2 = geo_distance_COOK(lonNext2, latNext2, lonNext3, latNext3);
        s3 = geo_distance_COOK(lonNext3, latNext3, lonNext1, latNext1);

        %AREA
        semiPeri = (s1 + s2 + s3)/2; %Semi-Perimeter
        nextArea = sqrt(semiPeri*(semiPeri-s1)*(semiPeri-s2)*(semiPeri-s3));

        %DEFORMATION CHECK----
        L = Lambda1(s1, s2, s3);
        if L <= errorQ || nextArea < 0.1
            continue
        end

    
        %CALCULATE PREV AREAS
        
        %VELOCITY COMPONENT ESTIMATES-------------------
        vb1 = (newStruc(drifterNum1).lat(index1) - newStruc(drifterNum1).lat(index1 - 1))/300; %Degrees per second, as 300 seconds in a 5-minute interval
        vb2 = (newStruc(drifterNum2).lat(index2) - newStruc(drifterNum2).lat(index2 - 1))/300;
        vb3 = (newStruc(drifterNum3).lat(index3) - newStruc(drifterNum3).lat(index3 - 1))/300;

        ub1 = (newStruc(drifterNum1).lon(index1) - newStruc(drifterNum1).lon(index1 - 1))/300; %Degrees per second, as 300 seconds in a 5-minute interval
        ub2 = (newStruc(drifterNum2).lon(index2) - newStruc(drifterNum2).lon(index2 - 1))/300;
        ub3 = (newStruc(drifterNum3).lon(index3) - newStruc(drifterNum3).lon(index3 - 1))/300;
        %----------------------------------
        
        
        %TRANSFORMATIONS------------------------------------
        %Transformed LAT/LON of PREV point 1

        latPrev1 = lat1 - 300*ub1;
        lonPrev1 = lon1 - 300*vb1;
        
        %Transformed LAT/LON of PREV point 2
        latPrev2 = lat2 - 300*ub2;
        lonPrev2 = lon2 - 300*vb2;
        
        %Transformed LAT/LON of PREV point 3
        latPrev3 = lat3 - 300*ub3;
        lonPrev3 = lon3 - 300*vb3; 
        %TRANSFORMATIONS^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

        %SIDE LENGTHS
        s1 = geo_distance_COOK(lonPrev1, latPrev1, lonPrev2, latPrev2);
        s2 = geo_distance_COOK(lonPrev2, latPrev2, lonPrev3, latPrev3);
        s3 = geo_distance_COOK(lonPrev3, latPrev3, lonPrev1, latPrev1);

        %AREA
        semiPeri = (s1 + s2 + s3)/2; %Semi-Perimeter
        prevArea = sqrt(semiPeri*(semiPeri-s1)*(semiPeri-s2)*(semiPeri-s3));

        %DEFORMATION CHECK----NOt currently necessary for next areas
        L = Lambda1(s1, s2, s3);
        %Lambda = 12*sqrt(3)*prevArea/((2*semiPeri)^2);
        if L <= errorQ || prevArea < 0.1
            continue
        end
%IF you are here, then all 3 triangles were not too small or deformed!
%Calculate divergence
        areaDiff = nextArea - prevArea;
        areaDiff = areaDiff/Area;
        div = areaDiff/600;
%FIND COM LAT
        meanLat = (lat1 + lat2 + lat3)/3;
%Normalize with coriolis
        output(i, 1) = div/coriolis(meanLat); %Now it has been changed from NaN to its true value
    
    end

end

function output2 = Lambda1(s11, s22, s33)
    semiPerimeter = (s11 + s22 + s33)/2;
    area = sqrt(semiPerimeter*(semiPerimeter-s11)*(semiPerimeter-s22)*(semiPerimeter-s33));
    
    output2 = 12*sqrt(3)*area/((2*semiPerimeter)^2);
end