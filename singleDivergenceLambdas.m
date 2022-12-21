function [datenums, output, lambdas] = singleDivergence(struc, drifterNum1, drifterNum2, drifterNum3, errorQ)
    datenums = find_datenum(struc);
    lenDate = length(datenums);
    output = NaN(lenDate, 1); %This will store divergence for each datenum for our triangle
    lambdas = NaN(lenDate, 1);
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
        L1 = Lambda1(s1, s2, s3);
        if Area < 0.1
            continue
        end
    
        %CALCULATE NEXT AREAS

        %LAT/LON Of next POINT 1
        lat1Next = struc(drifterNum1).lat(index1+1); 
        lon1Next = struc(drifterNum1).lon(index1+1);
    
        %LAT/LON Of next POINT 2
        lat2Next = struc(drifterNum2).lat(index2+1); 
        lon2Next = struc(drifterNum2).lon(index2+1);
        
        %LAT/LON Of next POINT 3
        lat3Next = struc(drifterNum3).lat(index3+1); 
        lon3Next = struc(drifterNum3).lon(index3+1);
        
        %SIDE LENGTHS
        s1 = geo_distance_COOK(lon1Next, lat1Next, lon2Next, lat2Next);
        s2 = geo_distance_COOK(lon2Next, lat2Next, lon3Next, lat3Next);
        s3 = geo_distance_COOK(lon3Next, lat3Next, lon1Next, lat1Next);

        %AREA
        semiPeri = (s1 + s2 + s3)/2; %Semi-Perimeter
        nextArea = sqrt(semiPeri*(semiPeri-s1)*(semiPeri-s2)*(semiPeri-s3));

        %DEFORMATION CHECK----
        L2 = Lambda1(s1, s2, s3);
        if nextArea < 0.1
            continue
        end

    
        %CALCULATE PREV AREAS

        %LAT/LON Of PREV POINT 1
        lat1Prev = struc(drifterNum1).lat(index1-1); 
        lon1Prev = struc(drifterNum1).lon(index1-1);
    
        %LAT/LON Of PREV POINT 2
        lat2Prev = struc(drifterNum2).lat(index2-1); 
        lon2Prev = struc(drifterNum2).lon(index2-1);
        
        %LAT/LON Of PREV POINT 3
        lat3Prev = struc(drifterNum3).lat(index3-1); 
        lon3Prev = struc(drifterNum3).lon(index3-1);

        %SIDE LENGTHS
        s1 = geo_distance_COOK(lon1Prev, lat1Prev, lon2Prev, lat2Prev);
        s2 = geo_distance_COOK(lon2Prev, lat2Prev, lon3Prev, lat3Prev);
        s3 = geo_distance_COOK(lon3Prev, lat3Prev, lon1Prev, lat1Prev);

        %AREA
        semiPeri = (s1 + s2 + s3)/2; %Semi-Perimeter
        prevArea = sqrt(semiPeri*(semiPeri-s1)*(semiPeri-s2)*(semiPeri-s3));

        %DEFORMATION CHECK----NOt currently necessary for next areas
        L3 = Lambda1(s1, s2, s3);
        %Lambda = 12*sqrt(3)*prevArea/((2*semiPeri)^2);
        if  prevArea < 0.1
            continue
        end
%IF you are here, then all 3 triangles were not too small!
%Calculate divergence
        areaDiff = nextArea - prevArea;
        areaDiff = areaDiff/Area;
        div = areaDiff/600;
%FIND COM LAT
        meanLat = (lat1 + lat2 + lat3)/3;
%Normalize with coriolis
        output(i, 1) = div/coriolis(meanLat); %Now it has been changed from NaN to its true value
        lambdas(i, 1) = mean([L1 L2 L3]);
    end

end

function output2 = Lambda1(s11, s22, s33)
    semiPerimeter = (s11 + s22 + s33)/2;
    area = sqrt(semiPerimeter*(semiPerimeter-s11)*(semiPerimeter-s22)*(semiPerimeter-s33));
    
    output2 = 12*sqrt(3)*area/((2*semiPerimeter)^2);
end