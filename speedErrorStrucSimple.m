function errorStruc = speedErrorStrucSimple(struc, maxspeed) %Outputs structure of indices that each drifter is erroenous
    len = length(struc);
    errorStruc = struct;
    errorStruc(len).indices = [];
    
    for i = 1:len
        speedVec = find_speed_vector(struc, i); %Get the speed vector, is a column vector
        logicalVec = (speedVec > maxspeed); %| isnan(speedVec); %Find which intervals had speed greater than maxspeed, or NaN values.
        len2 = length(speedVec);
        if len2 == 0 %No data, then move to next drifter
            continue
        end
        errorStruc(i).indices = find(~logicalVec); %These are the indices that drifter i is faster than max speed
        
        if speedVec(end) > maxspeed && speedVec(len2 - 1) > maxspeed %Final segment bad, remove final point too
            errorStruc(i).indices = cat(1, errorStruc(i).indices, len2 + 1);
        end
    end

end