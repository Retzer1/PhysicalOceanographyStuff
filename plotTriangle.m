function plotTriangle(positions, color)
lat1=positions(1,1);
lat2=positions(2, 1);
lat3=positions(3, 1);
lon1= positions(1, 2);
lon2 = positions(2, 2);
lon3 = positions(3, 2);
geoplot([lat1 lat2 lat3], [lon1 lon2 lon3], 'Marker', '.', 'Color', color)
end