function a = speed_12hr_trajectories(struc, rngOption)
datamatrix = arclen_matrix(struc);
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
    range_array = [0 rngOption]; %For WHOI, rngOption = 0.5066
end

for i = 1:length(struc) %Loop through each drifter in the dataset, this is our row # in the datamatrix
    
    second_length = length(struc(i).lat); %How many data points this drifter has
    numberOf12hr = nnz(datamatrix(i, :)); %How many 12-hr segments this drifter has 
    
    for k = 0:(numberOf12hr-1) %Loop through each latitude/longitude coordinate for a given drifter
        
        color = equiv_color(datamatrix(i, k+1), range_array); %Assign color according to arclength of the 12-hr segment that includes the point being plotted.    
        geoplot(struc(i).lat((1+k*144):(1+(k+1)*144)), struc(i).lon((1+k*144):(1+(k+1)*144)), 'Color', color)
        hold on
    end
end
%For appearance customization-------------------------------------------
%geolimits([37 42], [-1 9])  %For WHOI, [39.95 40.5], [2.13 3.2]
%geolimits([39.95 40.5], [2.13 3.2])
%geolimits([39.95 40.5], [1.95 3.15]);
geolimits([39.3 42.3], [0 6.02]) %USE FOR ALL DATA
geobasemap streets-dark;
gx = gca;
gx.GridColor = 'white';
a = gcf;
caxis(range_array)
colorbar
hold off
end
