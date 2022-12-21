function newstruc = quadSelectStruc(struc, lon1, lon2, minLat1, maxLat1, minLat2, maxLat2)
    newstruc = struc;
    %UPDATE STRUCTURE, no need to update SST fields, or filtered fields, or
    %u/v fields, as we are not using those now
    for i = 1:length(newstruc)
        indices = quadSelect(struc, i, lon1, lon2, minLat1, maxLat1, minLat2, maxLat2);
        newstruc(i).lat = newstruc(i).lat(indices);
        newstruc(i).lon = newstruc(i).lon(indices);
        newstruc(i).datenum = newstruc(i).datenum(indices);
        newstruc(i).indices = indices;
        %newstruc(i).lat0 = newstruc(i).lat(1);
        %newstruc(i).lon0 = newstruc(i).lon(1);
        %newstruc(i).datenum0 = newstruc(i).datenum(1);
        %newstruc(i).datenum_range = [newstruc(i).datenum0 newstruc(i).datenum(end)];
    end
end