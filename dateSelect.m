function output = dateSelect(struc, drifter, lowDate, highDate) %Finds indices at which a drifter is active during a user-set date
    firstIndex = LowerDateSelect(struc, drifter, lowDate);
    lastIndex = UpperDateSelect(struc, drifter, highDate);
    output = (firstIndex:lastIndex)'; %We want a column vector here
end
        
    