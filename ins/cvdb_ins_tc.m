function cvdb_ins_tc(conn,img1_id,img2_id,cfg_id,u)
    stereo_id = cvdb_hash_xor(img1_id,img2_id);
    
    what = {'tc'};
    opt = [];

    try
        if ~isempty(u)
            put_data(conn.cassandra, ...
                     cfg_id, ...
                     stereo_id, ...
                     u, ...
                     what);
        end
    catch err
        disp(err.message);
    end

function [] = put_data(cfg,cfg_id,stereo_id,s,what)
if (~iscell(what))
    what = {what};
end

do_tc = ismember('tc',what);

if (do_tc)
    put_tc(cfg,cfg_id,stereo_id,s);
end 

function [] = put_tc(cfg,cfg_id,stereo_id,tc)
cfg.storage.put(stereo_id,tc,['tc:' cfg_id],[]); 
