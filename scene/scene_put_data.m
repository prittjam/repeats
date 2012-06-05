function [x,is_found] = scene_put_data(data,img_id,label,key)
global conn;

if nargin < 4 
    key = [];
end

cvdb_ins_data(conn,data,img_id,label,key);