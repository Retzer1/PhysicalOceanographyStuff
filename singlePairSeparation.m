function [isPlotted, Vector] = singlePairSeparation(struc1, struc2, drifter1, drifter2, dist) %Plots, and can output whether the input pair was plotted
    %If useForAll = 1, then we want to pass in a datenum vector instead of
    %finding it each time
    datenums1 = find_datenum(struc1); %We only need one structure's datenum vector, because we're only working within the range of overlap between struc1 and struc2 anyway.
    len = length(datenums1);
    isPresent= zeros(len, 3);
    isPresent(:, 1) = datenums1;
    for i = 1:len 
        
        isPresent(i, 2) = whichdatenum(struc1, drifter1, isPresent(i, 1)); %Is drifter 1 present at time corresponding to this row, if so at what index?
        isPresent(i, 3) = whichdatenum(struc2, drifter2, isPresent(i, 1)); %Is drifter 2 present at time corresponding to this row, if so at what index?
    end
    separationVector = zeros(len, 1); %This vector is as long as the datenum vector is for the structure pair. That is, length of total datenum for struc1.
    for i = 1:len
        if isPresent(i, 2) && isPresent(i, 3) %If both drifters are present at time corresponding to row i
            
            separationVector(i) = geo_distance_COOK(struc1(drifter1).lon(isPresent(i, 2)), struc1(drifter1).lat(isPresent(i, 2)), struc2(drifter2).lon(isPresent(i, 3)), struc2(drifter2).lat(isPresent(i, 3))); %Distance between the drifter pair at the datenum corresponding to row i (i-th datenum of struc1's total datenum vector)
        else %Both drifters are not present at this time, don't plot this time
            separationVector(i) = NaN;
        end
        
    end
    firstIndex = find(separationVector <= dist, 1, 'first');
    if firstIndex > 0 %Note: we don't even plot it if the separation is always over dist
        separationVector = separationVector(firstIndex:end); %Trim the separation vector so initial separation is small
        plot(separationVector);
        xlabel('Number of 5-min intervals');
        ylabel('Kilometers')
        isPlotted = true;
    else %Not plotted
        isPlotted = false;
    end
    Vector = separationVector;
end