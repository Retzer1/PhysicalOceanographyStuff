function output = FlowFeatureSelectStrucPolygon(struc, TOP, BOT)
%Use with strucSelector function
%TOP is a 2-col matrix, 1st col is LONs, 2nd col is LATs, defining a
%piecewise-linear curve that forms the top of the polygon. BOT is a matrix
%of the same form that defines the piecewise-linear curve that is the
%bottom of the polygon. They need not have the same number of rows, but first and last x-vals must be same for TOP and BOT.
%     X       Y
%     x1      y1
%     x2      y2
%         .
%         .
%         .
%     xN      yN
    selectStruc = struct();
    strucLen = length(struc);
    TOPXVECTOR = TOP(:, 1);
    BOTXVECTOR = BOT(:, 1);
    TOPYVECTOR = TOP(:, 2);
    BOTYVECTOR = BOT(:, 2);
    for i = 1:strucLen
        select = [];
        drifterLen = length(struc(i).lat);
        for j = 1:drifterLen
            x = struc(i).lon(j);
            y = struc(i).lat(j);
            if (x > TOPXVECTOR(end) || x < TOPXVECTOR(1))
                continue
            end
            %At this point, we know the point is at least within the
            %x-bounds of our polygon
            
            TopIndexRight = find(TOPXVECTOR >= x, 1, 'first');
            TopIndexLeft = find(TOPXVECTOR <= x, 1, 'last');
            %At this point, the two indices above are either the same, or 1
            %apart, with TopIndex2 = TopIndex1 +1. Same goes for below
            %indices.
            BotIndexRight = find(BOTXVECTOR >= x, 1, 'first');
            BotIndexLeft = find(BOTXVECTOR <= x, 1, 'last');
            
            %Get longitudes for the right and left endpoints of the bin
            %that our current point falls under, for top and bottom defined
            %curves. Note: rightX and leftX may be the same if the
            %data point is right ON a bin divider, same for rightY and
            %leftY.
            rightXtop = TOPXVECTOR(TopIndexRight); 
            leftXtop = TOPXVECTOR(TopIndexLeft);
            rightXbot = BOTXVECTOR(BotIndexRight);
            leftXbot = BOTXVECTOR(BotIndexLeft);
            
            rightYtop = TOPYVECTOR(TopIndexRight); 
            leftYtop = TOPYVECTOR(TopIndexLeft);
            rightYbot = BOTYVECTOR(BotIndexRight);
            leftYbot = BOTYVECTOR(BotIndexLeft);
            
            %Define slopes
            topSlope = (rightYtop - leftYtop)/(rightXtop - leftXtop);
            botSlope = (rightYbot - leftYbot)/(rightXbot - leftXbot);
            
            %Test that current point is under top curve of its bin and over the bottom curve of its bin:
            isUnder = (y<= leftYtop + (x - leftXtop)*topSlope);
            if ~isUnder
                continue
            end
            isOver = (y>= leftYbot + (x - leftXbot)*botSlope);
            if ~isOver
                continue
            end
            
            %At this point, it's in range, so add the index of this data
            %point to our list, 'select'.
            select = [select j];
        end
        selectStruc(i).select = select;
    end
    output = strucSelector(struc, selectStruc); %NOTE: Trajectories may still need to be split due to gaps
end