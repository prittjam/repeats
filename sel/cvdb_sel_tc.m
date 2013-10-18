function varargout = cvdb_sel_tc(conn,img1_id,img2_id,cfg_id)
    cfg = conn.imagedb;
    
    opt = [];
    stereo_id = cvdb_hash_xor(img1_id,img2_id);
    what = {'tc'};

    [tc,is_found] = get_data(cfg,stereo_id,cfg_id,what);
    if ~isempty(tc)
        [~,ix] = sort({img1_id,img2_id});
        tc(ix,:) = tc;
    end
    
    varargout{1} = tc;
    varargout{2} = is_found;

function [tc,is_found] = get_data(cfg,img_id,key,what)
    tc=[];,is_found=false;
    if (~iscell(what))
        what = {what};
    end;

    do_tc = ismember('tc',what);

    if (do_tc)
        [tc,is_found] = cvdb_get_val(cfg,img_id,key,'tc');    
    end 