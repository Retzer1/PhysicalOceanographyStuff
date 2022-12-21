function output = geo_distance_COOK2(lon1, lat1, lon2, lat2)
    d = distance(lat1, lon1, lat2, lon2)
    d = deg2km(d);
end
    