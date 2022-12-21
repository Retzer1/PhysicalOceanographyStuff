function a = static_plot(struc)
datamatrix = arclen_matrix(struc);
dimensions = size(datamatrix);
%for i = 1:dimensions(1)
   % for k = 1:dimensions(2)
        %if arcmatrix(i, k) == 0
          %  arcmatrix(i, k) = NaN;
       % end
   % end

range_array = range(datamatrix);

for i = 1:length(struc) %Loop through each drifter in the dataset, this is our row # in the datamatrix
    
    second_length = length(struc(i).lat); %How many data points this drifter has
    for k = 1:second_length %Loop through each latitude/longitude coordinate for a given drifter
        d = i;
        color = equiv_color(datamatrix(d, (fix(k/144) + 1)), range_array); %Assign color according to arclength of the 12-hr segment that includes the point being plotted.    
        geoplot(struc(d).lat(k), struc(d).lon(k), '.', 'Color', color)
        hold on
    end
end
a = 1;
end
