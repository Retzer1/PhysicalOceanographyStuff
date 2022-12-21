function maxi = inst_speed_trajectory_single(struc, drifterNum, rngOption)
    speedVec = find_speed_vector(struc, drifterNum); %Vector of speeds of consecutive entries (between entries)
    if rngOption == 0
        range_array = range(speedVec);
    end

    if rngOption ~= 0
        range_array = [0 rngOption]; %For WHOI, rngOption = 0.5066
    end
    
    maxi = range_array(2);
    colorVec = equiv_color(speedVec, range_array);
    lengthNumber = length(struc(drifterNum).lat); %Number of entries for our drifter
    for i = 1:10:lengthNumber %You can do 1:5:lengthNumber, etc. if you want fewer points plotted
        
        if i == lengthNumber
            geoplot(struc(drifterNum).lat(i), struc(drifterNum).lon(i), 'Color', NewColor, 'Marker', '.') 
            hold on
        else
            
            NewColor = colorVec(i, :);
            if all(~isnan(NewColor))
                geoplot(struc(drifterNum).lat(i), struc(drifterNum).lon(i), 'Color', NewColor, 'Marker', '.')
                hold on
            end
               %Note, if color is nan, that means the lat/lon entries itself are nan, thus dont need to be plotted 
        end
    end
end

    
            