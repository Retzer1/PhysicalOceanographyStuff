function newAreaOutput = MonteCarloArea(positions) %Input a 3 x 2 matrix of positions of pts in a triangle
errorVector = zeros(3, 2); %Error vectors will be drawn from polar coordinates, of magnitude less than 5m and any angle
for i = 1:3
    r = 0.005*rand; %These are our r's/magnitudes in kilometers

    theta = 2*pi*rand; %These are our arguments/angles/theta's

    xdisp = r*cos(theta);

    ydisp = r*sin(theta);

    errorVector(i, :) = [xdisp ydisp];
end

newPositions = zeros(3, 2);
%FORMAT OF POSITIONS AND NEW POSITIONS is 3 x 2 matrix:
%[LAT1----LON1]
%[LAT2----LON2]
%[LAT3----LON3]
for i = 1:3
    newPositions(i, :) = findNewPosition(positions(i, :), errorVector(i, :));
end

newAreaOutput = Area(newPositions);
end

%BASED ON AN ERRORVECTOR and single pair of coordinates,
%FINDS NEW COORDINATES

function output = findNewPosition(coordinates, errorVector)
    xdisp = errorVector(1);
    ydisp = errorVector(2);
    
    ydist = abs(ydisp);
    xdist = abs(xdisp);
    
    lat = coordinates(1);
    lon = coordinates(2);
    if ydisp > 0
        signOfLatMove = 1;
    else
        signOfLatMove = -1;
    end
    
    if xdisp > 0
        signOfLonMove = 1;
    else
        signOfLonMove = -1;
    end
    
    %Find lat -----------------------------------------------
    hiLatMove = signOfLatMove*1;
    lowLatMove = 0;
    midPoint = mean([hiLatMove lowLatMove]);
    dist = geo_distance_COOK(lon, lat, lon, lat+midPoint);
    while abs(dist - ydist) > 0.0001 %Our epsilon is 0.0001 for now
        if dist > ydist + 0.0001 %Too far away
            hiLatMove = midPoint;
            midPoint = mean([hiLatMove lowLatMove]);
        elseif dist < ydist - 0.0001
            lowLatMove = midPoint;
            midPoint = mean([hiLatMove lowLatMove]);
        end
        dist = geo_distance_COOK(lon, lat, lon, lat+midPoint); %Recalculate using new midpoint
    end
    newLat = lat + midPoint;
    %Find lon -----------------------------------------------
    hiLonMove = signOfLonMove*1;
    lowLonMove = 0;
    midPoint = mean([hiLonMove lowLonMove]);
    dist = geo_distance_COOK(lon, lat, lon+midPoint, lat);
    while abs(dist - xdist) > 0.0001 %Our epsilon is 0.0001 for now
        if dist > xdist + 0.0001 %Too far away
            hiLonMove = midPoint;
            midPoint = mean([hiLonMove lowLonMove]);
        elseif dist < xdist - 0.0001
            lowLonMove = midPoint;
            midPoint = mean([hiLonMove lowLonMove]);
        end
        dist = geo_distance_COOK(lon, lat, lon+midPoint, lat); %Recalculate using new midpoint
    end
    newLon = lon + midPoint;
    output = [newLat newLon];
end    

%FINDS AREA OF A TRIANGLE, GIVEN COORDINATE MATRIX
function output = Area(positionList) %Position list has 3 rows, one for each point, and 2 columns, one for each coordinate (lat/lon). This function outputs area of the triangle.
    lat1 = positionList(1, 1);
    lat2 = positionList(2, 1);
    lat3 = positionList(3, 1);
    
    lon1 = positionList(1, 2);
    lon2 = positionList(2, 2);
    lon3 = positionList(3, 2);
    
    s1 = geo_distance_COOK(lon1, lat1, lon2, lat2);
    s2 = geo_distance_COOK(lon2, lat2, lon3, lat3);
    s3 = geo_distance_COOK(lon3, lat3, lon1, lat1);
    
    semiperimeter = (s1 + s2 + s3)/2;
    
    output = sqrt(semiperimeter*(semiperimeter - s1)*(semiperimeter-s2)*(semiperimeter-s3));
end



