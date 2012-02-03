function [] =  cvdb_ins_dr(conn,cfg,img_id,cfg_id,data)
what = {'geom','sifts'};
opt = [];

try
    if ~isempty(data)
        put_data(cfg, ...
                 cfg_id, ...
                 img_id, ...
                 data, ...
                 what);
    end
catch err
    disp(err.message);
end

function [] = put_data(cfg,cfg_id,img_id,s,what)
if (~iscell(what))
    what = {what};
end;

do_sifts = ismember('sifts',what);
do_geom = ismember('geom',what);

if (do_geom)
    put_geom(cfg,cfg_id,img_id,s.geom);
end 

if (do_sifts)
    put_sifts(cfg,cfg_id,img_id,s.sifts);           
end 

function [] = put_geom(cfg,cfg_id,img_id,geom)
cfg.storage.put(img_id,geom,['geom:' cfg_id],[]); 

function [] = put_sifts(cfg,cfg_id,img_id,sifts)
cfg.storage.put(img_id,sifts,['sifts:' cfg_id],[]);