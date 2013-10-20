function [] =  cvdb_ins_dr(conn,img_id,key,dr)
if ~isempty(dr)
    conn.imagedb.storage.put(img_id,dr,['dr:' key],[]); 
end
