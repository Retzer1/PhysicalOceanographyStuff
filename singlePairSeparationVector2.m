function [separationVector, firstIndices]= singlePairSeparationVector2(struc1, struc2, drifter1, drifter2, dist) %Use dist = inf if you don't care about initial distance
    datenums1 = find_datenum(struc1); %We only need one structure's datenum vector, because if there's no overlap, there's no overlap and it doesn't matter that we dont have the other structures.
    len = length(datenums1); %We could possibly replace datenums1 with an input argument, which will be the datenum array we want to use instead. 
    isPresent= zeros(len, 3);
    isPresent(:, 1) = datenums1;
    for i = 1:len 
        isPresent(i, 2) = whichdatenum(struc1, drifter1, isPresent(i, 1)); %IS drifter 1 present at time corresponding to this row, if so at what index?
        isPresent(i, 3) = whichdatenum(struc2, drifter2, isPresent(i, 1)); %Is drifter 2 present at time corresponding to this row, if so at what index?
    end
    separationVector = zeros(len, 1);
    for i = 1:len
        if isPresent(i, 2) && isPresent(i, 3) %If both drifters are present at time corresponding to row i
            
            separationVector(i) = geo_distance_COOK(struc1(drifter1).lon(isPresent(i, 2)), struc1(drifter1).lat(isPresent(i, 2)), struc2(drifter2).lon(isPresent(i, 3)), struc2(drifter2).lat(isPresent(i, 3)));
        else %Both drifters are not present at this time, don't plot this time
            separationVector(i) = NaN;
        end
        
    end
    firstIndex = find(separationVector <= dist, 1, 'first');
    
    if firstIndex > 0 %If there is some point where the separation is satisfactory, otherwise make separationvector all nans
        separationVector = separationVector(firstIndex:end); %NOTE: THIS IS UNNECESSARY. Trim the separation vector so initial separation is as small as desired. This is useful for 5-minute intervals on x-axis, but if we want datenum on x-axis, don't trim. Also, consistently use the same structure as struc1. 
        firstIndices = [isPresent(firstIndex, 2); isPresent(firstIndex, 3)]; %[x y] where x is the struc1 drifter's index at which it reaches the datenum associated with the row of the separation vector with satisfactory separation.
    else
        separationVector = NaN(len, 1);
        firstIndices = [NaN; NaN];
    end
end