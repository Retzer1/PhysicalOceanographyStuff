function output = latLonIndexRowVorticity(struc, daten) %Input a datenumber and structure, outputs a matrix whose rows correspond to rows of the structure/each drifter, and with a lat, lon columns, as well as a column indicating which index that drifter is present at our datenum, along with a column indicating which row that drifter appears in the input structure (for once we trim this, we lose that info otherwise).
    leng = length(struc);
    output = zeros(leng, 4);
    trimArray = [];
    for i = 1:leng
        output(i, 4) = i; %Keep track of which drifter this is in the structure
        output(i, 3) = whichdatenum(struc, i, daten); %When is this drifter present at daten? 
        if output(i, 3) < 2 || output(i, 3) > (length(struc(i).lon) - 1)
            trimArray = [trimArray i];
        end
    end
    output(trimArray, :) = []; %Leave out rows corresponding to drifters that have no entries, or their first/last entry, at this datenumber, as we always want there to be a next/prev position in order for their to always be a backward/forward difference velocity estimate at each time. 
    for i = 1:size(output, 1)    
        if output(i, 3) ~= 0 %Drifter is present, now compute U and V.
            output(i, 2) = struc(output(i, 4)).lon(output(i, 3)); %Because we trimmed first, before computing u and v, we had to use output(i, 4) as our index into the structure
            output(i, 1) = struc(output(i, 4)).lat(output(i, 3));
        end
    end
end %COL 1 = lat/v, col 2 = lon/u
        