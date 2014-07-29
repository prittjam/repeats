function [] = scene_put_desc(img_id,desc,res)
global conn

for k = 1:numel(res)
    if strcmp(desc(k).desc_writecache,'On')
        cvdb_ins_desc(conn,img_id,desc(k).key,res{k});
    end
end