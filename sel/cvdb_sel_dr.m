function [s,is_found] = cvdb_sel_dr(conn,cfg,img_id,cfg_id)
s = [];
is_found = true;
try 
    opt = [];
    what = {'geom','sifts'};
    s = get_data(cfg,img_id,cfg_id,what);
catch err
    disp(err.message);
    is_found = false;
end

function s = get_data(cfg,img_id,key,what)
    s = struct('geom',[],'sifts',[]);
    if (~iscell(what))
        what = {what};
    end;

    do_sifts = ismember('sifts',what);
    do_geom = ismember('geom',what);

    if (do_geom)
        s.geom = get_geom(cfg,img_id,key);
    end 

    if (do_sifts)
        tmp = get_sifts(cfg,img_id,key);
        s.sifts = reshape(typecast(tmp(:),'uint8'),128,[]);              end 

function geom = get_geom(cfg,img_id,key,geom)
    geom = cfg.storage.get(img_id,['geom:', key],[]); 

function sifts = get_sifts(cfg,img_id,key,sifts)
    sifts = cfg.storage.get(img_id,['sifts:', key],[]);