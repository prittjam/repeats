function [dr,is_found,num_dr,img_id] = scene_get_dr(img_id,cfg,gid)
global conn

dr = scene_construct_dr();

if nargin < 3
    gid = 1;
end

num_dr = 0;
[keys,subtypes,ids,subgenids] = cvdb_get_dr_keys(cfg);

for i = 1:numel(keys)
    [s is_found] = cvdb_sel_dr(conn, ...
                               img_id, ...
                               keys{i});
    if ~is_found
        break;
    end

    dr(i) = scene_construct_dr(s.geom,s.sifts,gid,cfg.subgenid(i),cfg,img_id);
    num_dr = num_dr+dr(i).num_dr;
    gid = gid+size(dr(i).geom,2);
end