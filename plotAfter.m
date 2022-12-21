function plotAfter(struc, drifter, start_time)
    %Plots drifter's trajectory from start_time to its end
    start_index = find(struc(drifter).datenum >= start_time, 1, 'first'); %Find first index where this drifter is after the desired start time
    geoplot(struc(drifter).lat(start_index:end), struc(drifter).lon(start_index:end))
    hold on
        
   
end
    
    