function plotAllBefore(struc, end_time)
    %Plots all drifters' trajectories from start to end_time
    for i = 1:length(struc)
        end_index = find(struc(i).datenum <= end_time, 1, 'last'); %Find last index where this drifter is before the desired end time
        geoplot(struc(i).lat(1:end_index), struc(i).lon(1:end_index))
        hold on
        
    end
    hold off %reset in case you want to draw for another end time in a loop
end