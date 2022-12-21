function plotAllBetweenTime(struc, start_time, end_time, flag)

    %Plots all drifters' trajectories from start_time to end_time
    for i = 1:length(struc)
        start_index = find(struc(i).datenum >= start_time, 1, 'first'); %Find first index where this drifter is at/after the desired start time
        end_index = find(struc(i).datenum <= end_time, 1, 'last');
        geoplot(struc(i).lat(start_index:end_index), struc(i).lon(start_index:end_index))
        hold on
    end
    
    %hold off
    %if flag == 1
    %    geolimits([
    %end
end
    
    