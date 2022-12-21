function mergedIndexStruc = mergeIndexStruc(struc1, struc2)
    mergedIndexStruc = struc1;
    for i = 1:length(struc1) %ASSUMING BOTH HAVE SAME LENGTH
        mergedIndexStruc(i).indices = union(struc1(i).indices, struc2(i).indices);
    end
end