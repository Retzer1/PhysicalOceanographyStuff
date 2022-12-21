function newStruc = manualIndexSelectorBest(struc, whichOnes) %Loops over some drifters in a structure, letting user crop/trim the data for each drifter, one at a time
%Does not select u, v, or f30/f60 fields.
newStruc = struct();

if whichOnes == 0 %We want to go through the entire structure
    leaveOut = []; %Drifters that we want to leave out of the selection
    for i = 1:length(struc)
        i %Tell the user which drifter we are on
        static_trajectory(1, struc, 0, i) %Plot current drifter's trajectory
        hold off %Make it so on next drifter the current plot disappears/is replaced by new plot
        pause()
        x = input('What indices do you want to select for this drifter?, 0 for leave out');%x is a vector, usually a range starting at 1, like 1:10
        while ~isnumeric(x) || isempty(x) || max(x) > length(struc(i).lat)
            x = input('What indices do you want to select for this drifter?, 0 for leave out');
        end
        if x == 0
            leaveOut = [leaveOut i];
            newStruc(i).lat = struc(i).lat;
            newStruc(i).lon = struc(i).lon;
            newStruc(i).datenum = struc(i).datenum;
            newStruc(i).datenum0 = struc(i).datenum0;
            newStruc(i).lat0 = struc(i).lat;
            newStruc(i).lon0 = struc(i).lon;
            newStruc(i).datenum_range = [newStruc(i).datenum0 newStruc(i).datenum(end)];
            continue
        end
        
        newStruc(i).lat = struc(i).lat(x);
        newStruc(i).lon = struc(i).lon(x);
        newStruc(i).datenum = struc(i).datenum(x);
        newStruc(i).datenum0 = struc(i).datenum(1);
        newStruc(i).lat0 = struc(i).lat(1);
        newStruc(i).lon0 = struc(i).lon(1);
        newStruc(i).datenum_range = [newStruc(i).datenum0 newStruc(i).datenum(end)];
        %if isfield(struc, 'sst')
        %    newStruc(i).sst = struc(i).sst(x);
        %end
    end
    if length(leaveOut)>0
        newStruc(leaveOut) = []; %Remove drifters that we wanted to leave out of the structure
    end
end
% 
if whichOnes ~= 0 %We want to go through a subset of the entire structure, not using this right now
    leaveOut = []; %Drifters that we want to leave out of the selection
    counter = 1;
    for i = whichOnes
        i %Tell the user which drifter we are on
        static_trajectory(1, struc, 0, i) %Plot current drifter's trajectory
        hold off %Make it so on next drifter the current plot disappears/is replaced by new plot
        pause()
        x = input('What indices do you want to select for this drifter?, 0 for leave out');%x is a vector, usually a range starting at 1, like 1:10
        while ~isnumeric(x) || isempty(x) || max(x) > length(struc(i).lat)
            x = input('What indices do you want to select for this drifter?, 0 for leave out');
        end
        if x == 0
            leaveOut = [leaveOut counter];
            newStruc(counter).lat = struc(i).lat;
            newStruc(counter).lon = struc(i).lon;
            newStruc(counter).datenum = struc(i).datenum;
            newStruc(counter).datenum0 = struc(i).datenum0;
            newStruc(counter).lat0 = struc(i).lat;
            newStruc(counter).lon0 = struc(i).lon;
            newStruc(counter).datenum_range = [newStruc(counter).datenum0 newStruc(counter).datenum(end)];
            counter = counter+1;
            continue
        end
        
        newStruc(counter).lat = struc(i).lat(x);
        newStruc(counter).lon = struc(i).lon(x);
        newStruc(counter).datenum = struc(i).datenum(x);
        newStruc(counter).datenum0 = struc(i).datenum(1);
        newStruc(counter).lat0 = struc(i).lat(1);
        newStruc(counter).lon0 = struc(i).lon(1);
        newStruc(counter).datenum_range = [newStruc(counter).datenum0 newStruc(counter).datenum(end)];
        %if isfield(struc, 'sst')
        %    newStruc(i).sst = struc(i).sst(x);
        %end
        counter = counter + 1;
    end
    if length(leaveOut)>0
        newStruc(leaveOut) = []; %Remove drifters that we wanted to leave out of the structure
    end
end

end
