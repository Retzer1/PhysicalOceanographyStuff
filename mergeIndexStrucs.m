function output = mergeIndexStrucs(input)
    len = length(input);
    output = input{1};
    for i = 2:len
        output = mergeIndexStruc(output, input{i});
    end
end