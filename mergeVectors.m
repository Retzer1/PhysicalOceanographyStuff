function output = mergeVectors(input) %INPUT IS A CELL ARRAY
    len = length(input);
    output = [];
    for i = 1:len
        output = union(output, input{i});
    end
end