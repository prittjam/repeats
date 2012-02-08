function [] =  cvdb_ins_data(conn,data,img_id,label,key)
if nargin < 6
    key = [];
end

opt = [];

try
    if ~isempty(data)
        conn.imagedb.storage.put(img_id,data,[label ':' key],[]); 
    end
catch err
    disp(err.message);
end