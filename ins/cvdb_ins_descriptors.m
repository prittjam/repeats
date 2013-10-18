function [] =  cvdb_ins_descriptors(conn,img_id,key,desc)
try
    if ~isempty(dr)
        conn.imagedb.storage.put(img_id,desc,['desc:' desc.key],[]); 
    end
catch err
    disp(err.message);
end