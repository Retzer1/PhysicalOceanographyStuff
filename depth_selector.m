function output_struc = depth_selector(struc, selected_depths)
indices = [];
for i = 1:length(selected_depths)
    indicesToAdd = find([struc(:).drogue_depth] == selected_depths(i));
    indices = [indices indicesToAdd];
end
output_struc = struc(indices);
end
