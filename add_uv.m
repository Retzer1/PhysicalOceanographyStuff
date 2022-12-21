function newStruc = add_uv(struc) %Using forward difference, compute u and v.
    newStruc = struc;
    for i = 1:length(struc)
        len = length(struc(i).lat);
        
        u = NaN(len, 1);
        v = NaN(len, 1);
        
        for j = 1:(len-1)
           [u1, v1] = ll_to_xy(struc(i).lon(j+1), struc(i).lat(j+1),struc(i).lon(j), struc(i).lat(j));
            u(j, 1) = u1/300;
            v(j, 1) = v1/300;
        end
        
        newStruc(i).u = u;
        newStruc(i).v = v; %Note: Last entry of u and v is NaN, as we can't forward-diff approximate the speed at final position
    end
end