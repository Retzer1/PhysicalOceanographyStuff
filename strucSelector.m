function newStruc = strucSelector(struc, selectStruc)
    len = length(struc);
    newStruc = struc;
    for i = 1:len
        newStruc(i).lat = newStruc(i).lat(selectStruc(i).select);
        newStruc(i).latf30 = newStruc(i).latf30(selectStruc(i).select);
        newStruc(i).latf60 = newStruc(i).latf60(selectStruc(i).select);
        
        newStruc(i).datenum = newStruc(i).datenum(selectStruc(i).select);
        
        newStruc(i).lon = newStruc(i).lon(selectStruc(i).select);
        newStruc(i).lonf30 = newStruc(i).lonf30(selectStruc(i).select);
        newStruc(i).lonf60 = newStruc(i).lonf60(selectStruc(i).select);
        
        newStruc(i).u = newStruc(i).u(selectStruc(i).select);
        newStruc(i).uf30 = newStruc(i).uf30(selectStruc(i).select);
        newStruc(i).uf60 = newStruc(i).uf60(selectStruc(i).select);
        
        newStruc(i).v = newStruc(i).v(selectStruc(i).select);
        newStruc(i).vf30 = newStruc(i).vf30(selectStruc(i).select);
        newStruc(i).vf60 = newStruc(i).vf60(selectStruc(i).select);
        
        newStruc(i).datenum0 = [newStruc(i).datenum(1) newStruc(i).datenum(end)];
        if isfield(newStruc, 'sst')
            newStruc(i).sst = newStruc(i).sst(selectStruc(i).select);
            newStruc(i).sstf30 = newStruc(i).sstf30(selectStruc(i).select);
            newStruc(i).sstf60 = newStruc(i).sstf60(selectStruc(i).select);
        end
    end
end
        
        