function newStruc = stepDateRemover(struc, startIndex)
    len = length(struc);
    errorStruc = struct();
    
    errorStruc(len).error = [];
    newStruc = struc;
    for i = startIndex:len %Step through each drifter, identifying and marking errors
        
        x = 1;
        while x == 1 %Error selection loop
            figure(1) %Resets the figures for each drifter
            clf
            plot(newStruc(i).datenum, newStruc(i).lat)
            figure(2)
            plot(newStruc(i).datenum, newStruc(i).lon)
            hold on
            hold off
            pause;
            pts = ginput(2); %Define our current selection segment. First point is left, second point is right.
            lowDate = pts(1, 1);
            highDate = pts(2, 1);

            indices = dateSelect(newStruc, i, lowDate, highDate); %These are our erroneous indices for this drifter
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
            return
        end
    end
    
    errorStruc = uniqueErrorStructure(errorStruc); %Remove the duplicates
    newStruc = errorRemover(struc, errorStruc); %Output the structure with erroneous data points set to NaN
end