function [] = scene_put_dr(cfg,img_id,dr)
global conn

fn = fieldnames(dr);

[keys,subtypes] = cvdb_get_dr_keys(cfg);

if (numel(subtypes) > 0)
    for i = 1:numel(keys)
        cvdb_ins_dr(conn,cfg,img_id,keys{i},dr.(subtypes{i}))
    end
else
    cvdb_ins_dr(conn,cfg,img_id,keys,dr)
end
