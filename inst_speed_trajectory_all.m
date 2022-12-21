function inst_speed_trajectory_all(struc, rngOption) %If rngOption == 0, then we use range of data for color. Otherwise, rngOption is an artificially imposed max data value for the purpose of coloring the trajectory.
    %With WHOI, rngOption = 0.9048
    if rngOption ~= 0
        rangeArray = [0 rngOption];
        for i = 1:length(struc)
            inst_speed_trajectory_single(struc, i, rngOption);
            hold on

        end
        %Below, modify the appearance of the plot as desired
        %geolimits([39.95 40.5], [2.13 3.2]); %Geolimits used for WHOI are [39.95 40.5], [2.13, 3.2]
        geolimits([39.95, 40.5], [1.95 3.15]);
        geobasemap satellite;

        gx = gca;
        gx.GridColor = 'white';
        caxis(rangeArray)
        colorbar
    else
        maxi = 0;
        for i = 1:length(struc)
            m = inst_speed_trajectory_single(struc, i, rngOption);
            hold on
            if m > maxi
                maxi = m;
            end

        end
        rangeArray = [0 maxi];
        %Below, modify the appearance of the plot as desired
        %geolimits([39.95 40.5], [2.13 3.2]); %Geolimits used for WHOI are [39.95 40.5], [2.13, 3.2]
        geolimits([39.95, 40.5], [1.95 3.15]);
        geobasemap satellite;

        gx = gca;
        gx.GridColor = 'white';
        caxis(rangeArray)
        colorbar
        
    
    end
    
    
    
end