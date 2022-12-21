function newStruc = flowFeatureSelectStruc(struc, minDate, maxDate, lon1, lon2, minLat1, maxLat1, minLat2, maxLat2)
%For now, we only care about lat/lon fields, and depth,
geoSelectedStruc = quadSelectStruc(struc, lon1, lon2, minLat1, maxLat1, minLat2, maxLat2);
newStruc = strucDateSelect(geoSelectedStruc, minDate, maxDate);
end
% 
% 
% 40.52 to 41.17, 40.59 to 41.17
% 2.25 to 3.02