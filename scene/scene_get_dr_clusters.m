function [cluster,is_found,num_clusters,img_id] = ...
    scene_get_clusters(img_id,cfg,gid)
global conn

num_dr = 0;
[keys,subtypes,ids,subgenids] = cvdb_get_dr_keys(cfg);

for i = 1:numel(keys)
    [s is_found] = cvdb_sel_clusters(conn,img_id);
    if ~is_found
        break;
    end
end