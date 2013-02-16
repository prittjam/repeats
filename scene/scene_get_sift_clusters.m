function [s,is_found,num_clusters,img_id] = ...
        scene_get_sift_clusters(dr)
global conn

num_clusters = 0;

[s is_found] = cvdb_sel_sift_clusters(conn,dr.img_id,dr.key);

if ~is_found
    return;
end

num_clusters = size(s,1);