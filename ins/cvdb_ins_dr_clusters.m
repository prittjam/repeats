function [] =  cvdb_ins_dr_clusters(conn,img_id,dr,clusters)
what = {'dr_clusters'};
opt = [];

try
    if ~isempty(clusters)
        put_data(conn.imagedb, ...
                 dr, ...
                 clusters, ...
                 img_id, ...
                 what);
    end
catch err
    disp(err.message);
end

function [] = put_data(cfg,dr,clusters,img_id,what)
if (~iscell(what))
    what = {what};
end;

do_clusters = ismember('dr_clusters',what);

if (do_clusters)
    put_clusters(cfg,dr.key,img_id,clusters);
end 


function [] = put_clusters(cfg,cfg_id,img_id,clusters)
[m,n] = size(clusters);
k = nnz(clusters);
cc = [];
for i = 1:n
    ia = find(clusters(:,k));
    cat(2,cc,[ia 0]);
end

cfg.storage.put(img_id,cc,['dr_clusters:' cfg_id],[]);