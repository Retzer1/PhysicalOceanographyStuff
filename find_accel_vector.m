function accelVec = find_accel_vector(struc, ID)

    speedVec = find_speed_vector(struc, ID); %This is our speed vector, time-normed change in dist from point i to point i+1. From which we will construct accel vector
    accelVec = diff(speedVec); %Entry i is change in speed from segment i to segment i+1. We can assign it to be the accel of point i.
    %Convert the above to accel. Forward diff, s(i+1) - s(i)/deltat is
    %approx equal to speed at i. Use this approximation to find accel. Diff
    %in segment 1 and segment 2 is diff in speed of i and i+1, take delta t
    %of i and i+1 and we are done.
    datenumDiff = diff(struc(ID).datenum); %datenum diff between entries
    datenumDiff = datenumDiff(1:end-1); %There is no data for acceleration of final 2 data point
    secDiff = datenumDiff / datenum([0 0 0 0 0 1]); %seconds diff between entries

    accelVec = accelVec ./ secDiff; %Now in m/s2
end
    