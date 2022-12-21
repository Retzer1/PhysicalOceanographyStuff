function speedMatrix = speedMatrix(struc)
    biggest = length(struc(1).lat);
    for i = 2:length(struc) %Find the longest data series in the structure
        if length(struc(i).lat) > biggest
            biggest = length(struc(i).lat);
        end
    end
    
    speedMatrix = zeros(biggest, length(struc)); 
    for k = 1:length(struc) %k is the drifter #
        len = length(struc(k).lat); %How long is the current drifter's dataset?

        kmVector = zeros(len-1, 1); %Set up vector for KM diff between entries

        for i = 1:(len-1) %i is the entry #
            kmVector(i) = geo_distance_COOK(struc(k).lon(i), struc(k).lat(i), struc(k).lon(i+1), struc(k).lat(i+1));
        end

        mVector = kmVector * 1000; %Vector for M diff between entries

        datenumDiff = diff(struc(k).datenum); %datenum diff between entries

        secDiff = datenumDiff / datenum([0 0 0 0 0 1]); %seconds diff between entries

        speedMatrix(1:len-1, k) = mVector ./ secDiff; %Calculate speed between consecutive entries, len - 1 of these, and place into corresponding column in speedMatrix
    end
end


%To use this to find errors, just take [M, I] = max(speedMatrix(struc)).
%Will tell you indices and maxs of each column (drifter).

