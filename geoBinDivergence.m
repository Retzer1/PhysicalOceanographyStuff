function output = geoBinDivergence(struc, errorQ, gridSize, rngArray)
TriList = DivergenceTriangleList(struc, errorQ);
cmocean('balance')
Lat = TriList(:, 1);
Lon = TriList(:, 2);
DIVS = TriList(:, 3);
lowLat = min(Lat);
upLat = max(Lat);
lowLon = min(Lon);
upLon = max(Lon);

lats = linspace(lowLat, upLat, gridSize+1);
lons = linspace(lowLon, upLon, gridSize+1);

for x = 1:gridSize
    for y = 1:gridSize
        %Find current grid square corners
        curLowLat = lats(y);
        curUpLat = lats(y+1);    
        curLowLon = lons(x);
        curUpLon = lons(x+1);
        
        %Find DIVS present 
        indices = find(Lat >= curLowLat & Lat <= curUpLat);
        indices = intersect(indices, find(Lon >= curLowLon & Lon <= curUpLon));
        
        if ~isempty(indices) %SOME triangle was in this square
            curDivs = DIVS(indices);
            averageValue = mean(curDivs);
            
            %Find color to give this grid square
            curColor = equiv_color(averageValue, rngArray, [0 1], cmocean('balance'));
            fill([curLowLon curLowLon curUpLon curUpLon], [curLowLat curUpLat curUpLat curLowLat], curColor);
            hold on
            
        else %Color the grid square BLACK, there were no triangles in this square 
            fill([curLowLon curLowLon curUpLon curUpLon], [curLowLat curUpLat curUpLat curLowLat], 'green');
            hold on
            cmocean('balance')
        end
    end
end
cmocean('balance')
caxis(rngArray);
colorbar;
output = 1;
end
