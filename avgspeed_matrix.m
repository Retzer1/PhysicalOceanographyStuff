function matrix_output = avgspeed_matrix(struc, hours, intervalInMinutes)
%This calculates a matrix where each row is a drifter in a certain structure, and the (i, j) entry
%is the h-hour average speed of the j-th h-hour segment for the i-th drifter in that structure.
%Row numbers correspond to the row numbers of the structure. That is, by
%"i-th code drifter", we mean the drifter with index i in
%the structure. This should be used by first creating many structures, each
%from either 2018 or 2019 datasets, where all of the drifters in each
%structure have the same depth. That can be done with depth_selector
%function.

%Note: interval is the number of minutes elapsed between data points for
%all drifters, 

maximum = 0;

%What is the length of the longest dataset for any drifter?
for i = 1:length(struc)
    if length(struc(i).datenum) > maximum
        maximum = length(struc(i).datenum);
    end
end

%Create the latitude and longitude matrices, each with as many columns as
%there are the length of the longest dataset for any drifter, and with as
%many rows as there are drifters in your structure. 

struc_lat = zeros(length(struc), maximum);
struc_lon = zeros(length(struc), maximum);

for i = 1:length(struc)
    struc_lat(i, 1:length(struc(i).lat)) = struc(i).lat';
    struc_lon(i, 1:length(struc(i).lon)) = struc(i).lon';
end

%Now actually create the arclength matrix. 
%Number of Data Points per h-hour segment: h * 60 / intervalMinutes =
%#MinutesPerHhourSegment / #MinutesPerInterval
numIntervals = hours * 60 / intervalInMinutes;

matrix_output = zeros(length(struc), (fix((maximum-1)/numIntervals) + 1));
for i = 1:length(struc)
    for j = 0:((fix(length(struc(i).lat)-1)/numIntervals) - 1)
        sum1 = 0;
        for k = 1:numIntervals
            sum1 = sum1 + geo_distance_COOK(struc_lon(i, j*numIntervals + k),struc_lat(i, j*numIntervals + k),struc_lon(i, j*numIntervals + (k+1)),struc_lat(i, j*numIntervals + (k+1))); %OUTPUT IN KM
        end
        matrix_output(i, j+1) = sum1;
    end
end
%Use below line to get from the h-hour arc length to the the h-hr avg speed in meters per second, matrix.
secondsInH = hours * 3600;
%Distance / Time, km / (h*3600) seconds, *1000 meters / km 
matrix_output = matrix_output * 1000 / (hours*3600);
end