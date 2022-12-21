function strucNew = errorFinder(struc)
    
    len = length(struc);
    strucNew = struct();
    strucNew(len).error = [];
    %Create error field
    %for i = 1:len
    %    struc(i).error = [];
   % end
    static_trajectory(0, struc, 1) %Plot, using dots, all drifter trajectories of struc
    x = 1;
    while x == 1
        pause;
        pts = ginput(2); %Define our current selection square. First point is top-left, second point is bottom-right. Min lon max lat, max lon min lat.
        lowLat = pts(2, 1);
        upLat = pts(1, 1);
        lowLon = pts(1, 2);
        upLon = pts(2, 2);
        for i = 1:len %Check all drifters for presence in the square
            indices = geoSquareSelect(struc, i, lowLat, upLat, lowLon, upLon);
            strucNew(i).error = cat(1, strucNew(i).error, indices); %Add erroneous indices with respect to present selection to current drifter's list of erroneous indices

        
        end
        x = input('1 for continue') %Make new selection?
    end
end