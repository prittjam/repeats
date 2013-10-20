function [s,is_found] = cvdb_sel_desc(conn,img_id,desc_key)
s = [];
%try
    is_found = conn.imagedb.storage.check(img_id,['descriptor:' desc_key],[]);
    if is_found
        s = conn.imagedb.storage.get(img_id,['descriptor:' desc_key],[]); 
    end
%ch err
% disp(err.message);
%