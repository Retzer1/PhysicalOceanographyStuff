function pairSeparationPlot(struc1, struc2, initDist) %This is not the one I'm using for most plots
    len1 = length(struc1);
    len2 = length(struc2);
    isOverlap = zeros(len1, len2);
    for i = 1:len1
        for j = 1:len2
            if struc1(i).datenum_range(1) > struc2(j).datenum_range(2) || struc2(j).datenum_range(1) > struc1(i).datenum_range(2)
                isOverlap(i, j) = 0;
            elseif struc1(i).datenum_range(1) < struc2(j).datenum_range(1) %Row came before column, but they overlap
                isOverlap(i, j) = 1;
            elseif struc1(i).datenum_range(1) > struc2(j).datenum_range(1) %Column came before row, but they overlap
                isOverlap(i, j) = 2;
            elseif struc1(i).datenum_range(1) == struc2(j).datenum_range(1) %Came at same time, and overlap
                isOverlap(i, j) = 1;
            end
        end
    end
    
    
    firstOverlap = zeros(len1, len2); %Index when later-deployed drifter has its first overlap with earlier-deployed drifter, for a given overlapping drifter pair
    for i = 1:len1
        for j = 1:len2
            if isOverlap(i, j) == 1 %Row drifter came first, so find the first index at which row drifter overlaps with col drifter
                
                firstOverlap(i, j) = min(find(struc1(i).datenum >= struc2(j).datenum_range(1)));
            end
            
            if isOverlap(i, j) == 2 %Col drifter came first, so find the first index at which col drifter overlaps with row drifter
                
                firstOverlap(i, j) = min(find(struc2(j).datenum >= struc1(i).datenum_range(1)));
            end
        end
    end
    
                
    %PLOTTING BEGINS HERE
    hold on %Prepare for future plots
    %4 cases: If row drifter starts first, finishes last, sepVecLen =
    %length(coldrifter). If row drifter starts first, finishes first,
    %sepVecLen = length(rowdrifter(firstOverlap(i, j):end)). If col drifter
    %starts first, finishes last, sepVecLen = length(rowdrifter). If col
    %drifter starts first, finishes first, sepVecLen =
    %length(coldrifter(firstOverlap(i, j):end)).
    
    for i = 1:len1
        i
        if i == 27
            breakpoint = 1;
        end
        for j = 1:len2
            j
            rowDrifterLength = length(struc1(i).datenum);
            colDrifterLength = length(struc2(j).datenum);
            if isOverlap(i, j) == 1 %Row drifter came first, but they overlap
                if struc1(i).datenum_range(2) >= struc2(j).datenum_range(2) %Row drifter starts first, and finishes last
                    sepVecLen = length(struc2(j).datenum); %Number of overlapping entries, is # of entries in separation vector for this pair
                    separationVec = separationVector(struc1, struc2, i, j, firstOverlap(i, j), 1, sepVecLen);
                    
                    firstIndex = min(find(separationVec < initDist));%First index at which the pair is within our desired separation
                    if firstIndex > 0 %If we have a valid first index
                        plot(separationVec(firstIndex:end));
                        
                    end
                   %otherwise, don't even plot this pair, it's separation
                   %never was satisfactory
                   
                elseif struc1(i).datenum_range(2) < struc2(j).datenum_range(2) %Row drifter starts first, finishes first
                    sepVecLen = length(struc1(i).datenum(firstOverlap(i, j):end)); %Number of overlapping entries, is # of entries in separation vector for this pair
                    separationVec = separationVector(struc1, struc2, i, j, firstOverlap(i, j), 1, sepVecLen);
                    firstIndex = min(find(separationVec < initDist));%First index at which the pair is within our desired separation
                    if firstIndex > 0 %If we have a valid first index
                        plot(separationVec(firstIndex:end));
                        
                    end
                end
                
                
            end
            if isOverlap(i, j) == 2 %Col drifter came first, but they overlap
                if struc2(j).datenum_range(2) >= struc1(i).datenum_range(2) %Col drifter starts first, and finishes last
                    sepVecLen = length(struc1(i).datenum); %Number of overlapping entries, is # of entries in separation vector for this pair
                    separationVec = separationVector(struc1, struc2, i, j, 1, firstOverlap(i, j), sepVecLen);
                    firstIndex = min(find(separationVec < initDist));%First index at which the pair is within our desired separation
                    if firstIndex > 0 %If we have a valid first index
                        plot(separationVec(firstIndex:end));
                        
                    end
                elseif struc2(j).datenum_range(2) < struc1(i).datenum_range(2) %Col drifter starts first, finishes first
                    sepVecLen = length(struc2(j).datenum(firstOverlap(i, j):end)); %Number of overlapping entries, is # of entries in separation vector for this pair
                    separationVec = separationVector(struc1, struc2, i, j, 1, firstOverlap(i, j), sepVecLen);
                    firstIndex = min(find(separationVec < initDist));%First index at which the pair is within our desired separation
                    if firstIndex > 0 %If we have a valid first index
                        plot(separationVec(firstIndex:end));
                        
                    end
                end
    
            end
            %If 0, just skip that pair and dont plot it
        end
    end