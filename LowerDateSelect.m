function output = LowerDateSelect(struc, drifter, minDate) %Tells us the first index a drifter passes minDate
    isBigger = struc(drifter).datenum >= minDate;
    output = min(find(isBigger));
end