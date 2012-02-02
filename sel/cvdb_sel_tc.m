function varargout = cvdb_sel_tc(conn,img1_id,img2_id,cfg_id)
    stereo_id = cvdb_hash_xor(img1_id,img2_id);
    cfg = conn.cassandra;
    
    tc = [];
    is_found = true;
    try 
        opt = [];
        what = {'tc'};
        tc = get_data(cfg,stereo_id,cfg_id,what);
    catch err
        disp(err.message);
        is_found = false;
    end

    varargout{1} = tc;
    varargout{2} = is_found;

function tc = get_data(cfg,img_id,key,what)
    if (~iscell(what))
        what = {what};
    end;

    do_tc = ismember('tc',what);

    if (do_tc)
        tc = get_tc(cfg,img_id,key);
    end 

function tc = get_tc(cfg,stereo_id,key,geom)
    tc = cfg.storage.get(stereo_id,['tc:', key],[]); 
