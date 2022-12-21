function output = UpperDateSelect(struc, drifter, maxDate) %Tells us the last index a drifter does not pass maxDate
    isBigger = struc(drifter).datenum <= maxDate;
    output = max(find(isBigger));
end