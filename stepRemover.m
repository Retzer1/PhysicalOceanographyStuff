function newStruc = stepRemover(struc)
%Does not erase points that were selected before moving on to next drifter,
%so it's not fully interactive program. 
    len = length(struc);
    errorStruc = struct();
    errorStruc(len).error = [];
    
    
    for i = 1:len %Step through each drifter, identifying and marking errors
        
        figure(1) %Resets the figures for each drifter
        clf
        static_trajectory(1, struc, 1, i)
        figure(2)
        static_trajectory(0, struc, 1, i)
        hold on
        firstNonNaN = min(find(~isnan(struc(i).lat))); %First non-NaN index
        geoplot(struc(i).lat(firstNonNaN), struc(i).lon(firstNonNaN), 'r*'); %Plot the start of drifter
        geoplot(struc(i).lat(end), struc(i).lon(end), 'b*'); %Plot end of drifter
        hold off
        x = 1;
        while x == 1 %Error selection loop
            pause;
            pts = ginput(2); %Define our current selection square. First point is top-left, second point is bottom-right. Min lon max lat, max lon min lat.
            lowLat = pts(2, 1);
            upLat = pts(1, 1);
            lowLon = pts(1, 2);
            upLon = pts(2, 2);
            indices = geoSquareSelect(struc, i, lowLat, upLat, lowLon, upLon);
            errorStruc(i).error = cat(1, errorStruc(i).error, indices); %Add erroneous indices with respect to present selection to current drifter's list of erroneous indices
            x = input('1 for continue') %Make new selection for this drifter?
        end
    end
    errorStruc = uniqueErrorStructure(errorStruc); %Remove the duplicates
    newStruc = errorRemover(struc, errorStruc); %Output the structure with erroneous data points set to NaN
end