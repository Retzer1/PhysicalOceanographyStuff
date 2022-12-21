function singleDateTrajectory(struc, drifter, datenumStruc, titleText) %Have an option to input datenum range too
    %datenumRange = range(find_datenum(struc));    %As long as the trajectories are from the same structure, it's okay. Otherwise, SPOT/WHOI all start within 5 minutes of each other, so we can use SPOT since it starts first AND finishes last.  
    datenumRange = range(find_datenum(datenumStruc)); %datenumStruc is the struc we get our datenum list from
    for i = 1:length(struc(drifter).lat)
        geoplot(struc(drifter).lat(i), struc(drifter).lon(i), 'Marker', '.', 'Color', equiv_color(struc(drifter).datenum(i), datenumRange));
        hold on
    end
    %APPEARANCE CUSTOMIZATION
    colorbar;
    caxis([-1 (datenumRange(2) - datenumRange(1))/0.003472222248092]);
    geolimits([39.95 40.5], [2.05 3.2])  %For WHOI, [39.95 40.5], [2.13 3.2]
    geobasemap satellite;
    title(titleText);
    gx = gca;
    gx.GridColor = 'white';
end

    