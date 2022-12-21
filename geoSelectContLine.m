%This function finds the indices of the data points that drifter drifterNum
%in structure struc, is contained within geographical squares selected by user.

function indices = geoSelectContLine(struc, drifterNum) %Returns a vector of indices at which drifterNum is within the user-selected geographic square
    x = 1;
    y = 0;
    while x == 1
        geoplot(struc(drifterNum).lat, struc(drifterNum).lon)
        pause;
        pts = ginput(2); %First point is top-left, second point is bottom-right. Min lon max lat, max lon min lat.
        lowLat = pts(2, 1);
        upLat = pts(1, 1);
        lowLon = pts(1, 2);
        upLon = pts(2, 2);
        len = length(struc(drifterNum).lat);
        latLon = zeros(len, 2);
        latLon(:, 1) = struc(drifterNum).lat;
        latLon(:, 2) = struc(drifterNum).lon;

        checkLat = latLon(:, 1) >= lowLat & latLon(:, 1) <= upLat; %This is a logical vector of length as many data points as we have for our drifter. 0 or 1 is used to indicate whether each data point is within our lat range.
        checkLon = latLon(:, 2) >= lowLon & latLon(:, 2) <= upLon; %Puts a 1 for indices where drifter is within our lon range, 0 otherwise
        checkIndices = checkLat & checkLon; %Puts a 0 if either lon or lat is out of range, 1 otherwise
        if y == 0 %Meaning this is our first go-around
            indices = find(checkIndices);
            x = input('Continue (1 for yes, 0 for no)')
        else %Indices already exists, second+ go-around
            cat(1, indices, find(checkIndices)); %Finds the row #s that survived, that is the indices of the data pts that survived our latest check, and appends to the current list of selected indices from previous checks
            x = input('Continue (1 for yes, 0 for no)')
        end
    end
end