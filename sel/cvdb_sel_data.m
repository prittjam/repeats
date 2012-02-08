function [data,is_found] = cvdb_sel_data(conn,img_id,label,key)
if nargin < 4
    key = [];
end

data = [];
is_found = true;
try 
    opt = [];
    data = conn.imagedb.storage.get(img_id, ...
                                    [label ':' key], ...
                                    []); 
catch err
    disp(err.message);
    is_found = false;
end