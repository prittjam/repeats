function [dr,is_found] =  cvdb_sel_dr(conn,img_id,key,dr)
dr = [];
%try
    is_found = conn.imagedb.storage.check(img_id,['dr:' key],[]);
    if is_found
        dr = conn.imagedb.storage.get(img_id,['dr:' key],[]); 
    end
%ch err
% disp(err.message);
%