function indexStruc = findIndices(origStruc, newStruc) %Finds indices of original structure that select for a selected structure
    %NOTE: Additional work needed for strucs with trimmed trajectories,
    %should keep track, but thankfully we have that in a notepad.
    len = length(origStruc);
    indexStruc = struct();
    for i = 1:len
        indexes = [];
        origDateVec = origStruc(i).datenum;
        for j = 1:length(newStruc(i).datenum)
            result = find(origDateVec <= newStruc(i).datenum(j) + 0.0015 & origDateVec >= newStruc(i).datenum(j) - 0.0015);
            if length(result) == 1
                indexes = [indexes result];
            end
        end
        indexStruc(i).indices = indexes;
    end
end
%REMEMBER TO USE SETDIFF AT SOME POINT
