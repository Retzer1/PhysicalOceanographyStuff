function indices = quadSelect(struc, drifterNum, lon1, lon2, minLat1, maxLat1, minLat2, maxLat2)
    %Outputs the indices that a single drifter in a structure is within a
    %flow feature, defined by a quadrilateral (not necessarily rectangle)
    len = length(struc(drifterNum).lat);
    latLon = zeros(len, 2);
    latLon(:, 1) = struc(drifterNum).lat;
    latLon(:, 2) = struc(drifterNum).lon;
    
    topPositions = linspace(maxLat1, maxLat2, len)';
    botPositions = linspace(minLat1, minLat2, len)';
    
    topSlope = (maxLat2 - maxLat1)/(lon2 - lon1);
    botSlope = (minLat2 - minLat1)/(lon2 - lon1);
    checkLat = latLon(:, 1) <= maxLat1 + topSlope*(latLon(:, 2)-lon1) & latLon(:, 1) >= minLat1 + botSlope*(latLon(:, 2)-lon1);
    checkLon = latLon(:, 2) >= lon1 & latLon(:, 2) <= lon2;
    
    %checkLat = latLon(:, 1) <= topPositions & latLon(:, 1) >= botPositions; %This is a logical vector of length as many data points as we have for our drifter. 0 or 1 is used to indicate whether each data point is within our lat range.
    %checkLon = latLon(:, 2) >= lon1 & latLon(:, 2) <= lon2; %Puts a 1 for indices where drifter is within our lon range, 0 otherwise
    checkIndices = checkLat & checkLon; %Puts a 0 if either lon or lat is out of range, 1 otherwise
    indices = find(checkIndices); %Finds the row #s that survived, that is the indices of the data pts that survived our checks
end