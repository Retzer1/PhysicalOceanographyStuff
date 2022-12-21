function newStruc = stepRemoverUpdating(struc, startIndex)
%Lets you step through each drifter in the structure, viewing its
%trajectory in two ways and graphically selecting points of the trajectory to flag for
%error
    len = length(struc);
    errorStruc = struct();
    
    errorStruc(len).error = [];
    newStruc = struc;
    for i = startIndex:len %Step through each drifter, identifying and marking errors
        
        x = 1;
        while x == 1 %Error selection loop
            figure(1) %Resets the figures for each drifter
            clf
            static_trajectory(1, newStruc, 1, i)
            figure(2)
            
            static_trajectory(0, newStruc, 1, i)
            hold on
            firstNonNaN = min(find(~isnan(newStruc(i).lat))); %First non-NaN index
            geoplot(newStruc(i).lat(firstNonNaN), newStruc(i).lon(firstNonNaN), 'r*'); %Plot the start of drifter
            geoplot(newStruc(i).lat(end), newStruc(i).lon(end), 'b*'); %Plot end of drifter
            hold off
            pause;
            pts = ginput(2); %Define our current selection square. First point is top-left, second point is bottom-right. Min lon max lat, max lon min lat.
            lowLat = pts(2, 1);
            upLat = pts(1, 1);
            lowLon = pts(1, 2);
            upLon = pts(2, 2);
            indices = geoSquareSelect(newStruc, i, lowLat, upLat, lowLon, upLon);
            errorStruc(i).error = cat(1, errorStruc(i).error, indices); %Add erroneous indices with respect to present selection to current drifter's list of erroneous indices

            %Update Section
            errorUpdateVector = unique(errorStruc(i).error);
            newStruc(i).lat(errorUpdateVector) = NaN; %Update our trajectory, NaNing the so-far identified erroenous indices for this drifter
            newStruc(i).lon(errorUpdateVector) = NaN;
            newStruc(i).datenum(errorUpdateVector) = NaN;
            x = input('1 for continue') %Make new selection for this drifter?
        end
        flag = input('Enter 100 to stop program and output so-far corrected structure'); %Give user option to pick up at a later time, saving their work
        if flag == 100
            errorStruc = uniqueErrorStructure(errorStruc); %Remove the duplicates
            newStruc = errorRemover(struc, errorStruc);
            i
            return
        end
        
    end
    
    errorStruc = uniqueErrorStructure(errorStruc); %Remove the duplicates
    newStruc = errorRemover(struc, errorStruc); %Output the structure with erroneous data points set to NaN
end