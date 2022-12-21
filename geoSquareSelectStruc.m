function newstruc = geoSquareSelectStruc(struc, lowLat, upLat, lowLon, upLon, speedIs) %Takes a structure of drifter data, outputs structure of drifter data trimmed to a single square goegraphical region
    if speedIs == 0 %Structure doesn't have field speed
        newstruc = struc;
        for i = 1:length(newstruc)
            indices = geoSquareSelect(newstruc, i, lowLat, upLat, lowLon, upLon);
            newstruc(i).lat = newstruc(i).lat(indices);
            newstruc(i).lon = newstruc(i).lon(indices);
            newstruc(i).datenum = newstruc(i).datenum(indices);
            newstruc(i).lat0 = newstruc(i).lat(1);
            newstruc(i).lon0 = newstruc(i).lon(1);
            newstruc(i).datenum0 = newstruc(i).datenum(1);
            newstruc(i).datenum_range = [newstruc(i).datenum0 newstruc(i).datenum(end)];
        end
    else
        newstruc = struc;
        for i = 1:length(newstruc)
            indices = geoSquareSelect(newstruc, i, lowLat, upLat, lowLon, upLon);
            newstruc(i).lat = newstruc(i).lat(indices);
            newstruc(i).lon = newstruc(i).lon(indices);
            newstruc(i).datenum = newstruc(i).datenum(indices);
            newstruc(i).speeds = newstruc(i).speeds(indices);
            newstruc(i).lat0 = newstruc(i).lat(1);
            newstruc(i).lon0 = newstruc(i).lon(1);
            newstruc(i).datenum0 = newstruc(i).datenum(1);
            newstruc(i).datenum_range = [newstruc(i).datenum0 newstruc(i).datenum(end)];
        end
    end
end