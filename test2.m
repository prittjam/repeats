greedy_repeats_init();
imparams = { 'dr_type','mser', ...
             'res_path','~/cvpr16' };
cfg = CFG.get(imparams{:});

img = Img('url','haus2.jpg');       
cid_cache = CASS.CidCache(img.cid); 

cc = [img.width/2 img.height/2];
dr = get_dr(img,cid_cache, ...
                {'type',cfg.dr.dr_type});
[~,drid2] = ismember([dr(:).drid],unique([dr(:).drid]));
tmp = mat2cell(drid2,1,ones(1,numel(drid2)));
[dr(:).drid] = tmp{:};

res = greedy_repeats(dr,cc, ...
                     'estimator','laf2xN_to_txN');

draw_results(img,res);
