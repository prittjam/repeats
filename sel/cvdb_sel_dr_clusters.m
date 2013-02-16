function [s is_found] = cvdb_sel_dr_clusters(conn,img_id,cfg_id)
s = [];
is_found = true;
try 
    opt = [];
    what = {'clusters'};
    s = get_data(conn.imagedb,img_id,cfg_id,what);
catch err
    disp(err.message);
    is_found = false;
end

function s = get_data(cfg,img_id,key,what)
if (~iscell(what))
    what = {what};
end;

do_clusters = ismember('clusters',what);

if (do_clusters)
    s = get_sift_clusters(cfg,img_id,key);
end 

function s = get_sift_clusters(cfg,img_id,key)
tmp = cfg.storage.get(img_id,['dr_clusters:' key],[]);
ind = find(tmp == 0);
m = numel(ind);
n = tmp(1);
s = sparse([],[],false,m,n);
b = 2;
for k = 1:m
    s(k,tmp(b:ind(k)-1)) = true;
    b = ind(k)+1;
end