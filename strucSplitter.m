function splitStruc = strucSplitter(struc, threshold)
    len = length(struc);
    splitStruc = struc;
    for i = 1:len %LOOP OVER ORIGINAL TRAJECTORIES ONLY, NOT SPLITTED ONES
        curLen = length(splitStruc);
        splitIndices = find(diff(struc(i).datenum)>=threshold);
        if ~isempty(splitIndices) % IF EMPTY, DONT DO ANYTHING, THIS DRIFTER CAN STAY AS IS
            numToSplit = length(splitIndices);
            if numToSplit == 1 %THERE IS ONLY TWO TRAJECTORIES TO SPLIT UP FOR THIS DRIFTER
                splitStruc(i).lat = struc(i).lat(1:splitIndices(1));
                splitStruc(i).lon = struc(i).lon(1:splitIndices(1));
                splitStruc(i).datenum = struc(i).datenum(1:splitIndices(1));
                
                splitStruc(curLen+1).lat = struc(i).lat(splitIndices(1)+1:end);
                splitStruc(curLen+1).lon = struc(i).lon(splitIndices(1)+1:end);
                splitStruc(curLen+1).datenum = struc(i).datenum(splitIndices(1)+1:end);
                splitStruc(curLen+1).modified = i;
            else %THERE IS MORE THAN 2 TRAJECTORIES TO SPLIT UP
                splitStruc(i).lat = struc(i).lat(1:splitIndices(1));
                splitStruc(i).lon = struc(i).lon(1:splitIndices(1));
                splitStruc(i).datenum = struc(i).datenum(1:splitIndices(1));
                
                for j = 2:(numToSplit)
                    splitStruc(curLen+j-1).lat = struc(i).lat(splitIndices(j-1)+1:splitIndices(j));
                    splitStruc(curLen+j-1).lon = struc(i).lon(splitIndices(j-1)+1:splitIndices(j));
                    splitStruc(curLen+j-1).datenum = struc(i).datenum(splitIndices(j-1)+1:splitIndices(j));
                    splitStruc(curLen+j-1).modified = i;
                end
                splitStruc(curLen+numToSplit).lat = struc(i).lat(splitIndices(numToSplit)+1:end);
                splitStruc(curLen+numToSplit).lon = struc(i).lon(splitIndices(numToSplit)+1:end);
                splitStruc(curLen+numToSplit).datenum = struc(i).datenum(splitIndices(numToSplit)+1:end);
                splitStruc(curLen+numToSplit).modified = i;
            end
        end
    end
end