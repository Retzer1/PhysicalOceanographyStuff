function gridPlotter(lowLat, upLat, lowLon, upLon, stepSize)
    tall = (upLat - lowLat)/stepSize; %How tall is our rectangular grid?
    wide = (upLon - lowLon)/stepSize; %How long is our rectangular grid?
    
    for j = 0:wide
        geoplot([lowLat upLat], [lowLon+(j*stepSize) lowLon+(j*stepSize)], 'Color', 'b')
        hold on
    end
    
    for i = 0:tall
        geoplot([lowLat+(i*stepSize) lowLat + (i*stepSize)], [lowLon upLon], 'Color', 'b')
        hold on
    end
    geoplot([upLat upLat], [lowLon upLon], 'Color', 'b')
end
    
        