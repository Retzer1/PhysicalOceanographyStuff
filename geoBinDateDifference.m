function geoBinDateDifference(struc, lowLat, lowLon, stepSize, latNumber, lonNumber) %Grid goes from lowLat to lowLat + latNumber*stepSize, lowLon + lonNumber*stepSize. In other words, it is a latNumber x lonNumber grid. 
%Input structure must have field 'speed', a speed vector which is of length
%one less than the lat/long vectors, forward difference estimate. Note:
%lat/long vectors should be trimmed to have same length.
curStruc = struc;
%Add speeds field to structure
for i = 1:length(struc)
    curStruc(i).speeds = find_speed_vector(curStruc, i);
end
%Trim entries without an assigned forward-difference speed
for i = 1:length(struc)
    curStruc(i).lat(end) = [];
    curStruc(i).lon(end) = [];
    curStruc(i).datenum(end) = [];
    curStruc(i).datenum_range(2) = curStruc(i).datenum(end);
end
    %At this point, lat/lon/datenum/speed fields are all of the same size
    %for each drifer
    dataMatrix = zeros(latNumber, lonNumber);
    %Gather the information to go into our dataMatrix
for y = 0:latNumber-1
    for x = 0:lonNumber - 1 %We always work from lower-left corner of each grid square
        curLowLat= lowLat + y*stepSize;
        curLowLon = lowLon + x*stepSize;
        curUpLon = lowLon + (x+1)*stepSize;
        curUpLat = lowLat + (y+1)*stepSize;
        currentStruc = geoSquareSelectStruc2(curStruc, curLowLat, curUpLat, curLowLon, curUpLon, 1); %Crop to current working square of the grid
        maxDiff = maxDateDiff(currentStruc);
        dataMatrix(latNumber - y, x+1) = maxDiff;
        
    end
end

    %Generate our range array
    rangeArray = range(dataMatrix);
    
    %Actually color a corresponding grid
    for y = 0:(latNumber - 1)
        for x = 0:(lonNumber - 1)
            curLowLat= lowLat + y*stepSize;
            curLowLon = lowLon + x*stepSize;
            curUpLon = lowLon + (x+1)*stepSize;
            curUpLat = lowLat + (y+1)*stepSize;
            curColor = equiv_color(dataMatrix(latNumber - y, x+1), rangeArray);
            if all(~isnan(curColor)) %curColor will be all NaNs when there were no entries present in this grid square
                fill([curLowLon curLowLon curUpLon curUpLon], [curLowLat curUpLat curUpLat curLowLat], curColor);
                hold on
            else 
                curColor = equiv_color(0, rangeArray);
                fill([curLowLon curLowLon curUpLon curUpLon], [curLowLat curUpLat curUpLat curLowLat], curColor);
                hold on
            end
            
        end
    end
    ylim([lowLat lowLat + latNumber*stepSize])
    xlim([lowLon lowLon+lonNumber*stepSize])
    caxis(rangeArray);
    colorbar
end

function output = maxDateDiff(struc)
    maxi = 0;
    len = length(struc);
    for i = 1:len
        curData = max(struc(i).datenum);
        if curData > maxi
            maxi = curData;
        end
    end
    mini = maxi;
    for i = 1:len
        curData = min(struc(i).datenum);
        if curData < mini
            mini = curData;
        end
    end
    output = (maxi - mini)/datenum([0 0 1 0 0 0]); %How many days of difference in our grid square?
end

function newstruc = geoSquareSelectStruc2(struc, lowLat, upLat, lowLon, upLon, speedIs)
    if speedIs == 0 %Structure doesn't have field speed
        newstruc = struc;
        for i = 1:length(newstruc)
            indices = geoSquareSelect(newstruc, i, lowLat, upLat, lowLon, upLon);
            newstruc(i).lat = newstruc(i).lat(indices);
            newstruc(i).lon = newstruc(i).lon(indices);
            newstruc(i).datenum = newstruc(i).datenum(indices);
            
            
            
        end
    else
        newstruc = struc;
        for i = 1:length(newstruc)
            indices = geoSquareSelect(newstruc, i, lowLat, upLat, lowLon, upLon);
            newstruc(i).lat = newstruc(i).lat(indices);
            newstruc(i).lon = newstruc(i).lon(indices);
            newstruc(i).datenum = newstruc(i).datenum(indices);
            newstruc(i).speeds = newstruc(i).speeds(indices);
           
        end
    end
    
end

    


    