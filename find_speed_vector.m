function output = find_speed_vector(struc, ID)
    %Output in m/s, finds speed vector (for consecutive entries) for a
    %single drifter, ID is the number of the drifter (not ID number, but
    %rather row number in structure).
   
    len = length(struc(ID).lat); %How long is the current drifter's dataset?

    kmVector = zeros(len-1, 1); %Set up vector for KM diff between entries

    for i = 1:(len-1) %i is the entry #
        kmVector(i) = geo_distance_COOK(struc(ID).lon(i), struc(ID).lat(i), struc(ID).lon(i+1), struc(ID).lat(i+1));
    end

    mVector = kmVector * 1000; %Vector for M diff between entries

    datenumDiff = diff(struc(ID).datenum); %datenum diff between entries

    secDiff = datenumDiff / datenum([0 0 0 0 0 1]); %seconds diff between entries

    output = mVector ./ secDiff; %Calculate speed between consecutive entries, len - 1 of these, and place into corresponding column in speedMatrix
    
end


%To use this to find errors, just take [M, I] = max(speedMatrix(struc)).
%Will tell you indices and maxs of each column (drifter).

