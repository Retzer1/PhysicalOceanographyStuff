function plotBetweenTime(struc, drifter, start_time, end_time)
    %Plots drifter's trajectory from start_time to end_time
    
    
    start_index = find(struc(drifter).datenum >= start_time, 1, 'first'); %Find first index where this drifter is after the desired start time
    end_index = find(struc(drifter).datenum <= end_time, 1, 'last');
    geoplot(struc(drifter).lat(start_index:end_index), struc(drifter).lon(start_index:end_index))
    hold on
        
    
end
    
    