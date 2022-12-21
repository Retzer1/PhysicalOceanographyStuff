function newStruc = uniqueErrorStructure(errorStruc)
    newStruc = errorStruc;
    for i = 1:length(errorStruc)
        newStruc(i).error = unique(newStruc(i).error);
    end





end