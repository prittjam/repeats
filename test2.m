imparams = { 'dr_type','mser', ...
             'res_path','~/cvpr16' };
cache_params = { 'read_cache',false, ...
                 'write_cache',false };
greedy_repeats_init();
cfg = CFG.get(imparams{:});
img = Img('url','DSC_0810.jpg');       
cid_cache = CASS.CidCache(img.cid,cache_params{:}); 

cc = [img.width/2 img.height/2];
dr = get_dr(img,cid_cache, ...
                {'type',cfg.dr.dr_type});
[~,drid2] = ismember([dr(:).drid],unique([dr(:).drid]));
tmp = mat2cell(drid2,1,ones(1,numel(drid2)));
[dr(:).drid] = tmp{:};
