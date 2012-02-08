function [dr,is_found,num_dr,img_id] = scene_get_dr(img,cfg,idx)
global conn

dr = struct;

if nargin < 3
    idx = 1;
end

num_dr = 0;
img_id = cvdb_hash_img(img);
[keys,subtypes,ids,subgenids] = cvdb_get_dr_keys(cfg);

for i = 1:numel(keys)
    [s is_found] = cvdb_sel_dr(conn, ...
                               cfg, ...
                               img_id, ...
                               keys{i});
    if ~is_found
        continue;
    end
    dr(i).geom = s.geom;
    dr(i).sifts = s.sifts;
    dr(i).id = [idx:idx+size(dr(i).geom,2)-1];
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
    idx = idx+size(dr(i).geom,2);
end


function [dr,num_dr] = scene_add_dr(cfg,geom,sift,img_id,subgenid,idx)
[keys,subtypes,ids,subgenids] = cvdb_get_dr_keys(cfg);
dr = struct;

num_dr = size(geom,2);

dr.name = cfg.detector.name;
dr.subgenid = subgenids(subgenid);
dr.subtype.name = subtypes{subgenid};
dr.subtype.id = ids(subgenid);
dr.geom = geom;
dr.sifts = sift; 
dr.s = true(1,size(geom,2));
dr.id = [idx:idx+num_dr-1];

scene_put_dr(cfg,keys{subgenid},img_id,dr);