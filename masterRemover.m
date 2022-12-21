function newStruc = masterRemover(struc)
    errorStruc = errorFinder(struc); %This is manual, the user selects geographic squares where everything within is considered erroneous.
    errorStruc = uniqueErrorStructure(errorStruc); %This removes duplicates
    newStruc = errorRemover(struc, errorStruc); %For each drifter in structure, convert ITS specific errorenous data points to NaN
end
    