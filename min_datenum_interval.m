function output = min_datenum_interval(struc) %DOes not work if all drifters have no data
    for i = 1:length(struc) %Use when some drifters have no data
        if ~isempty(struc(i).datenum())
            output = min(diff(struc(i).datenum)); 
            break
        end
    end
    %output = min(diff(struc(1).datenum)); %USE WHEN ALL DRIFTERS HAVE DATA
    for i = 1:length(struc)
        if ~isempty(struc(i).datenum())
            if min(diff(struc(i).datenum)) < output
                output = min(diff(struc(i).datenum));
            end
        end
    end
end
        