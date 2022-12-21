function newStruc = extractLatLonDatenum(struc) %Outputs a copy structure with ONLY lat, lon, and datenum fields
    newStruc = struct();
    for i = 1:length(struc)
        newStruc(i).lat = struc(i).lat;
        newStruc(i).lon = struc(i).lon;
        newStruc(i).datenum = struc(i).datenum;
    end
end