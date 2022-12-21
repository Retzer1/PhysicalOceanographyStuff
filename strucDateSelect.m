function newStruc = strucDateSelect(struc, minDate, maxDate)
    newStruc = struc;    
    if ~isfield(struc, 'sst')
        %For now, we don't modify SST, so don't use it
        for i = 1:length(struc)
            selectionIndices = dateSelect(struc, i, minDate, maxDate);
            newStruc(i).lat = newStruc(i).lat(selectionIndices);
            newStruc(i).lon = newStruc(i).lon(selectionIndices);
            newStruc(i).datenum = newStruc(i).datenum(selectionIndices);
        end
        
    else 
        
        for i = 1:length(struc)
            selectionIndices = dateSelect(struc, i, minDate, maxDate);
            newStruc(i).lat = newStruc(i).lat(selectionIndices);
            newStruc(i).lon = newStruc(i).lon(selectionIndices);
            %newStruc(i).lat0 = newStruc(i).lat(1);
            %newStruc(i).lon0 = newStruc(i).lon(1);
            newStruc(i).datenum = newStruc(i).datenum(selectionIndices);
            %newStruc(i).datenum_range = [newStruc(i).datenum(1) newStruc(i).datenum(end)];
            %newStruc(i).sst = newStruc(i).sst(selectionIndices);
        end
    end
    
end

        