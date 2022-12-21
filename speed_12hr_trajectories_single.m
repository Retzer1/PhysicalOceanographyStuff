function a = speed_12hr_trajectories_single(struc, rngOption, i) %i is the drifter #
datamatrix = arclen_matrix(struc); %Arclen_matrix currently set up to calculate a 12-hr speed matrix, not arclength matrix. We find all 12-hr avg speeds, because the color-coding should be based on all trajectories in the structure, not just on this trajectories' fastest/slowest 12-hr segments. Otherwise yellow would mean a different speed for each drifter's trajectory, which is not useful.
dimensions = size(datamatrix);
%for i = 1:dimensions(1)
   % for k = 1:dimensions(2)
        %if arcmatrix(i, k) == 0
          %  arcmatrix(i, k) = NaN;
       % end
   % end
if rngOption == 0
    range_array = range(datamatrix);
end

if rngOption ~= 0
    range_array = [0 rngOption]; %For WHOI depths, use rngOption = 0.5066, the max 12-hr avg speed
end


second_length = length(struc(i).lat); %How many data points this drifter has
numberOf12hr = nnz(datamatrix(i, :)); %How many 12-hr segments this drifter has 

for k = 0:(numberOf12hr-1) %Loop through each latitude/longitude coordinate for a given drifter

    color = equiv_color(datamatrix(i, k+1), range_array); %Assign color according to arclength of the 12-hr segment that includes the point being plotted.    
    geoplot(struc(i).lat((1+k*144):(1+(k+1)*144)), struc(i).lon((1+k*144):(1+(k+1)*144)), 'Color', color)
    hold on
end

%For appearance customization-------------------------------------------
%geolimits([39.95 40.5], [2.05 3.2])  %For WHOI, [39.95 40.5], [2.13 3.2]
geobasemap satellite;
%title('SPOT D7 Drifter 9, 12-hr avg speed')
gx = gca;
gx.GridColor = 'white';
a = gcf;
caxis(range_array)
colorbar
end
