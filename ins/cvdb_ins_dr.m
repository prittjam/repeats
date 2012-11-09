function [] =  cvdb_ins_dr(conn,img_id,dr)
what = {'geom','sifts'};
opt = [];

try
    if ~isempty(dr)
        put_data(conn.imagedb, ...
                 dr, ...
                 img_id, ...
                 what);
    end
catch err
    disp(err.message);
end

function [] = put_data(cfg,dr,img_id,what)
if (~iscell(what))
    what = {what};
end;

do_sifts = ismember('sifts',what);
do_geom = ismember('geom',what);

if (do_geom)
    put_geom(cfg,dr.key,img_id,dr.geom);
end 

if (do_sifts)
    put_sifts(cfg,dr.key,img_id,dr.sifts);           
    put_class(cfg,dr.key,img_id,dr.class);
end 

function [] = put_geom(cfg,cfg_id,img_id,geom)
cfg.storage.put(img_id,geom,['geom:' cfg_id],[]); 

function [] = put_sifts(cfg,cfg_id,img_id,sifts)
cfg.storage.put(img_id,sifts,['sifts:' cfg_id],[]);

function [] = put_class(cfg,cfg_id,img_id,cls)
cfg.storage.put(img_id,cls,['class:' cfg_id],[]);