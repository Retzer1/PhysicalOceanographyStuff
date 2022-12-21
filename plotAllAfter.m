function plotAllAfter(struc, start_time)
    %Plots all drifters' trajectories from start_time to their end
    for i = 1:length(struc)
        start_index = find(struc(i).datenum >= start_time, 1, 'first'); %Find first index where this drifter is after the desired start time
        geoplot(struc(i).lat(start_index:end), struc(i).lon(start_index:end))
        hold on
        
    end
end
    
    