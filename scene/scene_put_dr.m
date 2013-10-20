function [] = scene_put_dr(img_id,dr,res)
global conn

for k = 1:numel(res)
    if strcmp(dr(k).writecache,'On')
        cvdb_ins_dr(conn,img_id,dr(k).key,res{k});
    end
end
