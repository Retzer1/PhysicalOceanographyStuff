function xy_gridPlotter(lowLat, upLat, lowLon, upLon, stepSize)
    tall = (upLat - lowLat)/stepSize; %How tall is our rectangular grid?
    wide = (upLon - lowLon)/stepSize; %How long is our rectangular grid?
    
    for j = 0:wide
        plot([lowLon+(j*stepSize) lowLon+(j*stepSize)],[lowLat upLat], 'Color', 'b')
        hold on
    end
    
    for i = 0:tall
        plot([lowLon upLon],[lowLat+(i*stepSize) lowLat + (i*stepSize)], 'Color', 'b')
        hold on
    end
    plot([lowLon upLon], [upLat upLat], 'Color', 'b')
    xlim([2.38 2.9])
    ylim([40.07 40.41])
end
    
        