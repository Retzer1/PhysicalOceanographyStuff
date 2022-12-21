function Newstruc = errorRemover(struc, errorStruc)
    Newstruc = struc;
    len = length(struc);
    if isfield(struc, 'sst')
        for i = 1:len
            Newstruc(i).datenum(errorStruc(i).error) = NaN; %NaN out the erroneous data points
            Newstruc(i).lat(errorStruc(i).error) = NaN;
            Newstruc(i).lon(errorStruc(i).error) = NaN;
            Newstruc(i).sst(errorStruc(i).error) = NaN;
        end
    else
        for i = 1:len
            Newstruc(i).datenum(errorStruc(i).error) = NaN; %NaN out the erroneous data points
            Newstruc(i).lat(errorStruc(i).error) = NaN;
            Newstruc(i).lon(errorStruc(i).error) = NaN;
        end
    end
end
