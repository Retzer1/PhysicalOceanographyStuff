function [maxChange, drifterNum, maxChanges] = maxDateChange(struc)
    maxChange = 0;
    drifterNum = 0;
    maxChanges = zeros(length(struc), 1);
    for i = 1:length(struc)
        maxNow = max(diff(struc(i).datenum));
        if maxNow > 0
            maxChanges(i, 1) = maxNow;
        end
        if maxNow>maxChange
            maxChange = maxNow
            drifterNum = i;
        end
    end
end