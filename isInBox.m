function result = isInBox(lat, lon, minLat, minLon, maxLat, maxLon) %Use for moving box
    result = 0;
    if (lat >= minLat && lat <= maxLat) && (lon >= minLon && lon <= maxLon)
        result = 1;
   end




end