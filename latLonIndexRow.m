function output = latLonIndexRow(struc, daten) %Input a datenumber and structure, outputs a matrix whose rows correspond to rows of the structure/each drifter, and with a lat, lon columns, as well as a column indicating which index that drifter is present at our datenum, along with a column indicating which row that drifter appears in the input structure (for once we trim this, we lose that info otherwise).
    leng = length(struc);
    output = zeros(leng, 4);
    trimArray = [];
    for i = 1:leng
        output(i, 4) = i; %Keep track of which drifter this is in the structure
        output(i, 3) = whichdatenum(struc, i, daten); %When is this drifter present at daten?
        if output(i, 3) < 2 || output(i, 3) == length(struc(i).lon) 
            trimArray = [trimArray i];
        end
        if output(i, 3) ~= 0 %Drifter is present
            output(i, 2) = struc(i).lon(output(i, 3)); %What is its lon at daten?
            output(i, 1) = struc(i).lat(output(i, 3)); %What is its lat at daten?
        end
    end
    output(trimArray, :) = []; %Leave out rows corresponding to drifters that have their first entry, or no entries, or their last entry, at this datenumber.
end
        