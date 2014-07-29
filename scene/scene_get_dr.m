function [res,is_found] = scene_get_dr(img_id,detectors,image_cache)
res = cell(1,numel(detectors));
is_found = false(1,numel(detectors));

for k = 1:numel(res)
    if strcmp(detectors(k).dr_readcache,'On')
        [res{k},isf] = cvdb_sel_dr(conn,img_id,[detectors(k).name detectors(k).key]);
        is_found(k) = isf;
    end
end

is_found = logical(is_found);