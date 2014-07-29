function [res,is_found] = scene_get_desc(img_id,descriptors)
global conn

res = cell(1,numel(descriptors));
is_found = false(1,numel(descriptors));

for k = 1:numel(res)
    if strcmp(descriptors(k).read_cache,'On')
        [res{k},isf] = cvdb_sel_desc(conn,img_id,descriptors(k).key);
        is_found(k) = isf;
    end
end

is_found = logical(is_found);