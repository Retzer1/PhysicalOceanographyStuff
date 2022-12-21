function newStruc = selectBefore(struc, maxDate)
    newStruc = struc;
    
    if ~isfield(struc, 'sst')
        %For now, we don't modify SST, so don't use it
        for i = 1:length(struc)
            selectionIndices = 1:UpperDateSelect(newStruc, i, maxDate);
            newStruc(i).lat = newStruc(i).lat(selectionIndices);
            newStruc(i).lon = newStruc(i).lon(selectionIndices);
            newStruc(i).datenum = newStruc(i).datenum(selectionIndices);
        end
        
    else 
        
        for i = 1:length(struc)
            selectionIndices = 1:UpperDateSelect(struc, i, maxDate);
            newStruc(i).lat = newStruc(i).lat(selectionIndices);
            newStruc(i).lon = newStruc(i).lon(selectionIndices);
            newStruc(i).datenum = newStruc(i).datenum(selectionIndices);
            %newStruc(i).sst = newStruc(i).sst(selectionIndices);
        end
    end
    
end

        