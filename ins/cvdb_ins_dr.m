function [] =  cvdb_ins_dr(conn,img_id,key,dr)
try
    if ~isempty(dr)
        conn.imagedb.storage.put(img_id,dr,['dr:' dr.key],[]); 
    end
catch err
    disp(err.message);
end