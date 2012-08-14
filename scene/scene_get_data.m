function [x,is_found] = scene_get_data(img_id,label,key)
global conn;

if nargin < 3 
    key = [];
end

[x,is_found] = cvdb_sel_data(conn,img_id,label);