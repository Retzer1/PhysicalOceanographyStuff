function newStruc = manualIndexSelector(struc, whichOnes) %Loops over some drifters in a structure, letting user crop/trim the data for each drifter, one at a time

newStruc = struc;
if whichOnes == 0 %We want to go through the entire structure

for i = 1:length(struc)
    i %Tell the user which drifter we are on
    x = input('What indices do you want to select for this drifter?');%x is a vector, usually a range starting at 1, like 1:10
    newStruc(i).lat = newStruc(i).lat(x);
    newStruc(i).lon = newStruc(i).lon(x);
    newStruc(i).datenum = newStruc(i).datenum(x);
    newStruc(i).datenum0 = newStruc(i).datenum(1);
    newStruc(i).lat0 = newStruc(i).lat(1);
    newStruc(i).lon0 = newStruc(i).lon(1);
    newStruc(i).datenum_range = [newStruc(i).datenum0 newStruc(i).datenum(end)];
    if isfield(struc, 'sst')
        newStruc(i).sst = newStruc(i).sst(x);
    end
end
end

if whichOnes ~= 0 %We want to go through a subset of the entire structure

for i = whichOnes
    i
    x = input('What indices do you want to select for this drifter?');%x is a vector
    newStruc(i).lat = newStruc(i).lat(x);
    newStruc(i).lon = newStruc(i).lon(x);
    newStruc(i).datenum = newStruc(i).datenum(x);
    newStruc(i).datenum0 = newStruc(i).datenum(1);
    newStruc(i).lat0 = newStruc(i).lat(1);
    newStruc(i).lon0 = newStruc(i).lon(1);
    newStruc(i).datenum_range = [newStruc(i).datenum0 newStruc(i).datenum(end)];
    if isfield(struc, 'sst')
        newStruc(i).sst = newStruc(i).sst(x);
    end
end
end

end
