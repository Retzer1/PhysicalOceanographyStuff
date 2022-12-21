function errorStruc = speedErrorStruc(struc, maxspeed)
    len = length(struc);
    errorStruc = struct;
    errorStruc(len).indices = [];
    
    for i = 1:len
        speedVec = find_speed_vector(struc, i); %Get the speed vector, is a column vector
        speedVec = (speedVec > maxspeed) | isnan(speedVec); %Find which intervals had speed greater than maxspeed,1 is bad, 0 is good, we want NaNs convert to 0.
        len2 = length(speedVec);
        if len2 == 0 %No data, then move to next drifter
            continue
        end
        
        downShiftVec = cat(1, [1;], speedVec(1:(len2-1)));
        upShiftVec = cat(1, speedVec(2:end), 1);
        flagVector = (downShiftVec & speedVec & upShiftVec) | (downShiftVec & speedVec & ~upShiftVec) | (~downShiftVec & speedVec & ~upShiftVec); %BBB, BBG, GBG cases, then data point i is bad, with segment i being the middle of BBB, BBG, or GBG
        %With flag vector, we now know what data pts need be removed.
        %Issue: What if bad segment is last in the data set. But this is
        %unlikely. Dealt with below:
        errorStruc(i).indices = find(flagVector); %This tells us what indices need to be removed for drifter i
        if speedVec(end) && speedVec(len2 - 1) %Final and penultimate segments bad
            errorStruc(i).indices = cat(1, errorStruc(i).indices, [len2; len2 + 1]);
        elseif speedVec(end) && ~(speedVec(len2 - 1)) %Penultimate segment good, final segment bad
            errorStruc(i).indices = cat(1, errorStruc(i).indices, len2+1);
        end
    end

end