function errorStruc = accelErrorStruc(struc, maxAccel)
    len = length(struc);
    errorStruc = struct;
    errorStruc(len).indices = [];
    
    for i = 1:len
        accelVec = find_accel_vector(struc, i); %Get the accel vector, is a column vector
        accelVec = (accelVec > maxAccel); %| isnan(accelVec); %Find which intervals had bad accel
        len2 = length(accelVec);
        if len2 == 0 %No data, then move to next drifter
            continue
        end

        errorStruc(i).indices = find(accelVec); %This tells us what indices need to be removed for drifter i
    end

end