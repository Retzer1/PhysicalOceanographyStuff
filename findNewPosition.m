function [newLat, newLon] = findNewPosition(coordinates, errorVector) %errorVector is displacement vector in meters. Note: Must be < 1km in displacement, this is best used for instantaneous stuff.
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
    hiLatMove = signOfLatMove*1.00000000000000000;
    lowLatMove = 0;
    midPoint = (hiLatMove + lowLatMove)/2;
    dist = geo_distance_COOK(lon, lat, lon, lat+midPoint);
    while abs(dist - ydist) > 1*10^-4 %Our epsilon is 0.0001 for now
        if dist > ydist + 1*10^-4 %Too far away
            hiLatMove = midPoint;
            midPoint = (hiLatMove + lowLatMove)/2;
        elseif dist < ydist - 1*10^-4
            lowLatMove = midPoint;
            midPoint = (hiLatMove + lowLatMove)/2;
        end
        dist = geo_distance_COOK(lon, lat, lon, lat+midPoint); %Recalculate using new midpoint
    end
    newLat = lat + midPoint;
    %Find lon -----------------------------------------------
    hiLonMove = signOfLonMove*1.00000000000000000; %Will not find if distance is too great (only jumps 1 deg longitude max).
    lowLonMove = 0;
    midPoint = (hiLonMove + lowLonMove)/2;
    dist = geo_distance_COOK(lon, lat, lon+midPoint, lat);
    while abs(dist - xdist) > 1*10^-4 %Our epsilon is 0.0001 for now
        if dist > xdist + 1*10^-4 %Too far away
            hiLonMove = midPoint;
            midPoint = (hiLonMove + lowLonMove)/2;
        elseif dist < xdist - 1*10^-4
            lowLonMove = midPoint;
            midPoint = (hiLonMove + lowLonMove)/2;
        end
        dist = geo_distance_COOK(lon, lat, lon+midPoint, lat); %Recalculate using new midpoint
    end
    newLon = lon + midPoint;
    
end    