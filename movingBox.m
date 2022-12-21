function newStruc = movingBox (struc, datenumVector, minLatVector, minLonVector, maxLatVector, maxLonVector)
    %As input, do struc, find_datenum(struc), 
    %Assumes all drifters have data, no gaps
    %Often error results because input arrays are not all col vectors,
    %check that all are col vectors before calling the function.
    indexStruc = struct();
    usefulMatrix = cat(2, datenumVector, minLatVector, minLonVector, maxLatVector, maxLonVector);
    for i = 1:length(struc)
        indexes = [];
        if length(struc(i).lat) > 0
            for j = 1:length(struc(i).lat)
                curDate = struc(i).datenum(j);
                dateIndex = find(datenumVector <= (curDate + 0.002) & datenumVector >= (curDate - 0.002));
                curMinLat = usefulMatrix(dateIndex, 2);
                curMinLon = usefulMatrix(dateIndex, 3);
                curMaxLat = usefulMatrix(dateIndex, 4);
                curMaxLon = usefulMatrix(dateIndex, 5);
                if isInBox(struc(i).lat(j), struc(i).lon(j), curMinLat, curMinLon, curMaxLat, curMaxLon)
                    indexes = [indexes j];
                end
            end
        end
        indexStruc(i).indices = indexes;
    end
    newStruc = extractLatLonDatenumIndices(struc, indexStruc);
end