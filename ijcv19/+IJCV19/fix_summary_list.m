function summary_list = fix_summary_list(summary_list)

for k = 1:size(summary_list,1)
    splt = strsplit(summary_list(k,:).img_path{:},'/');
    all_camera_names{k} = splt{end-1};
end

[camera_names,~,ind] = unique(all_camera_names);
camera_category_list = categorical([1:numel(ind)], ...
                                   [1:numel(ind)], ...
                                   camera_names(ind), ...
                                   'Ordinal', true);

summary_list.camera_name = camera_names(ind)';