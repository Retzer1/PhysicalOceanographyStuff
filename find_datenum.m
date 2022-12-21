function output = find_datenum(struc) %Create a datenum column vector for a structure, using minimum interval stepsizes
for i = 1:length(struc) %Use when some drifters have no data
    if ~isempty(struc(i).datenum())
        minimum = struc(i).datenum(1); %Find first drifter that has data, assign its first datenum as the min datenum for the structure
        break
    end
end
    
%minimum = struc(1).datenum(1); Use this when all drifters have data
for i = 1:length(struc)
   if ~isempty(struc(i).datenum())
       if struc(i).datenum(1) < minimum
           minimum = struc(i).datenum(1);
       end
   end
end

%maximum = struc(1).datenum(end); Use this when all drifters have data
for i = 1:length(struc) %Use when some drifters have no data
    if ~isempty(struc(i).datenum())
        maximum = struc(i).datenum(end); %Find first drifter that has data, assign its last datenum as the max datenum for the structure
        break
    end
end

for i = 1:length(struc)
    if ~isempty(struc(i).datenum())
        if struc(i).datenum(end) > maximum
            maximum = struc(i).datenum(end);
        end
    end
end
stepSize = min_datenum_interval(struc); %Usually 0.0035
output = minimum:stepSize:(maximum + stepSize); %Assumes all drifters have same time diff up to a multiple, like 12:05, 12:10, 12:20 is okay, 12:05, 12:10, 12:17 is not
end
%DOes not work if all drifters have no data
