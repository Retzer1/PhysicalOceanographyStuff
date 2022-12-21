function newStruc = accelRemover(struc, maxAccel)
    len = length(struc);
    errorStruc = accelErrorStruc(struc, maxAccel);
    newStruc = struc;
    for i = 1:len
        if isfield(struc, 'sst')
            newStruc(i).datenum(errorStruc(i).indices) = NaN;
            newStruc(i).lat(errorStruc(i).indices) = NaN;
            newStruc(i).lon(errorStruc(i).indices) = NaN;
            newStruc(i).sst(errorStruc(i).indices) = NaN;
        else
            newStruc(i).datenum(errorStruc(i).indices) = NaN;
            newStruc(i).lat(errorStruc(i).indices) = NaN;
            newStruc(i).lon(errorStruc(i).indices) = NaN;
        end
    end
end
