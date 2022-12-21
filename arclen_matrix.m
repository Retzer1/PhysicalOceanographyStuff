function matrix_output = arclen_matrix(struc)
%This calculates a matrix where each row is a drifter in a certain structure, and the (i, j) entry
%is the arclength of the j-th 12 hour segment for the i-th drifter in that structure.
%Row numbers correspond to the row numbers of the structure. That is, by
%"i-th code drifter", we mean the drifter with index i in
%the structure. This should be used by first creating many structures, each
%from either 2018 or 2019 datasets, where all of the drifters in each
%structure have the same depth. That can be done with depth_selector
%function.

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

matrix_output = zeros(length(struc), (fix((maximum-1)/144) + 1));
for i = 1:length(struc)
    for j = 0:((fix(length(struc(i).lat)-1)/144) - 1)
        sum1 = 0;
        for k = 1:144
            sum1 = sum1 + geo_distance_COOK(struc_lon(i, j*144 + k),struc_lat(i, j*144 + k),struc_lon(i, j*144 + (k+1)),struc_lat(i, j*144 + (k+1)));
        end
        matrix_output(i, j+1) = sum1;
    end
end
%Use below line to get the 12-hr avg speed matrix.
matrix_output = matrix_output/43.2;
end