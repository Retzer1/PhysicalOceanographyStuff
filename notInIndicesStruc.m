function newStruc = notInIndicesStruc(struc, indexStruc) %Selects a structure that is NOT selected by indexStruc
    len = length(struc);
    newStruc = struc;
    for i = 1:len
        set1 = 1:length(struc(i).datenum);
        set2 = indexStruc(i).indices;
        selectionIndices = setdiff(set1, set2);
        newStruc(i).lat = struc(i).lat(selectionIndices);
        newStruc(i).lon = struc(i).lon(selectionIndices);
        newStruc(i).datenum = struc(i).datenum(selectionIndices);
    end
end
%ONLY USE THIS AFTER INDEXSTRUC IS COMPLETE, WITH SPLIT TRAJECTORY INDICES
%ADDED TO DRIFTERS THAT WERE SPLIT/HAVE DATA BEYOND THE ORIGINAL LENGTH
%POINT