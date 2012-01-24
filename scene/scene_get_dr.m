function [dr,num_dr,img_id] = scene_get_dr(img,cfg,idx)
global conn

if nargin < 3
    idx = 1;
end

num_dr = 0;
img_id = cvdb_hash_img(img);
[keys,subtypes] = cvdb_make_dr_keys(cfg);
dr = struct;
if (numel(subtypes) > 0)
    for i = 1:numel(keys)
        [dr.(subtypes{i}) is_found] = cvdb_sel_dr(conn, ...
                                                  cfg, ...
                                                  img_id, ...
                                                  keys{i});
        if ~is_found
            break;
        end
    end
    
    if ~is_found
        dr = scene_make_dr(img,cfg);
        for i = 1:numel(keys)
            cvdb_ins_dr(conn, ...
                        cfg, ...
                        img_id, ...
                        keys{i}, ...
                        dr.(subtypes{i}));
        end
    end

    for i = 1:numel(subtypes)
        dr.(subtypes{i}).id = [idx:idx+size(dr.(subtypes{i}).geom, ...
                                            2)-1];
        num_dr = num_dr+size(dr.(subtypes{i}).geom,2);
        idx = idx+size(dr.(subtypes{i}).geom,2);
    end
else
    [dr is_found] = cvdb_sel_dr(conn,cfg,img_id,keys{1});
    if ~is_found
        dr = scene_make_dr(img,cfg);
        cvdb_ins_dr(conn, ...
                    cfg, ...
                    img_id, ...
                    keys{1}, ...
                    dr);
    end
    dr.id = [idx:idx+size(dr.geom,2)-1];
    num_dr = size(dr,2);
    idx = idx+size(dr.geom,2);
end