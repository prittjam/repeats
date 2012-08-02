function [dr,is_found,num_dr,img_id] = scene_get_dr(img_id,cfg,gid)
global conn

dr = struct;

if nargin < 3
    gid = 1;
end

num_dr = 0;
[keys,subtypes,ids,subgenids] = cvdb_get_dr_keys(cfg);

for i = 1:numel(keys)
    [s is_found] = cvdb_sel_dr(conn, ...
                               cfg, ...
                               img_id, ...
                               keys{i});
    if ~is_found
        break;
    end
    dr(i).geom = s.geom;
    dr(i).u = laf_get_3p_from_A(laf_unwrap_A(geom));
    dr(i).sifts = s.sifts;
    dr(i).id = [1:size(dr(i).geom,2)];
    dr(i).gid = [gid:gid+size(dr(i).geom,2)-1];
    dr(i).s = true(1,size(dr(i).geom,2));
    dr(i).num_dr = size(s.geom,2);
    dr(i).name = cfg.detector.name;
    dr(i).subgenid = cfg.subgenid(i);

    if (numel(subtypes) > 0)
        dr(i).subtype.name = subtypes(i);
        dr(i).subtype.id = ids(i);
    else
        dr(i).subtype.name = [];
        dr(i).subtype.id = [];
    end

    num_dr = num_dr+size(dr(i).geom,2);
    gid = gid+size(dr(i).geom,2);
end