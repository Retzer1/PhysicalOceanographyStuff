function newStruc = extractLatLonDatenumIndices(struc, indexStruc) %Outputs a copy structure with ONLY lat, lon, and datenum fields
    newStruc = struct();
    for i = 1:length(struc)
        newStruc(i).lat = struc(i).lat(indexStruc(i).indices);
        newStruc(i).lon = struc(i).lon(indexStruc(i).indices);
        newStruc(i).datenum = struc(i).datenum(indexStruc(i).indices);
    end
end