%This function returns a vector of the indices of the data points that drifter drifterNum
%in structure struc, is contained within a geographical square, with lowLat
%and upLat determining the latitude range of the square.

function indices = geoSquareSelect(struc, drifterNum, lowLat, upLat, lowLon, upLon)
    len = length(struc(drifterNum).lat);
    latLon = zeros(len, 2);
    latLon(:, 1) = struc(drifterNum).lat;
    latLon(:, 2) = struc(drifterNum).lon;
    
    checkLat = latLon(:, 1) >= lowLat & latLon(:, 1) <= upLat; %This is a logical vector of length as many data points as we have for our drifter. 0 or 1 is used to indicate whether each data point is within our lat range.
    checkLon = latLon(:, 2) >= lowLon & latLon(:, 2) <= upLon; %Puts a 1 for indices where drifter is within our lon range, 0 otherwise
    checkIndices = checkLat & checkLon; %Puts a 0 if either lon or lat is out of range, 1 otherwise
    indices = find(checkIndices); %Finds the row #s that survived, that is the indices of the data pts that survived our checks
end