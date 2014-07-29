function [cc,num_clusters] = desc_get_clusters(clust_cfg,descriptors,dr)
is_found = false;

%if strcmp(clust_cfg.readcache,'On')
%    [cc,is_found,num_clusters] = ...
%        scene_get_dr_clusters(cdr(k2));
%end
%
%if ~is_found
    [cc,num_clusters] = desc_cluster(clust_cfg,dr);
%    if strcmp(clust_cfg.writecache,'On')
%        scene_put_dr_clusters(cdr(k2),cc(k2).s);
%    end
%end