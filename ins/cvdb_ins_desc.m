function [] =  cvdb_ins_desc(conn,img_id,key,desc)
try
    if ~isempty(desc)
        conn.imagedb.storage.put(img_id,desc,['descriptor:' key],[]); 
    end
catch err
    disp(err.message);
end