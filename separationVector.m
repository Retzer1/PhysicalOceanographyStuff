function output = separationVector(struc1, struc2, drifter1, drifter2, index1, index2, len)
    output = zeros(1, len);
    for i = 1:len
        output(i) = geo_distance_COOK(struc1(drifter1).lon(index1 + i-1), struc1(drifter1).lat(index1 + i-1), struc2(drifter2).lon(index2 + i-1), struc2(drifter2).lat(index2 + i-1));
    end
end
