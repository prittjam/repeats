function [] = test()
greedy_repeats_init();

%listA = { 'fireengine1.jpg' };
%listA = {'liz_taylor.jpg'};
%listA = {'object0149.view01.png'};
% listA = {'226148941_00d29de16b_o.jpg'};
%listA = {'PSWT12.JPG'};
% listA = { 'SY_darts.jpg' };
%listA = { 'fairey2.png' };
%listA = { 'wp006.png' };
%listA = { 'sett4.jpg' };
%listA = { 'calib_prague3.jpg' };
% listA = { '2063499388_567bd68634_o.jpg' };
% listA = { 'two_planes.jpg' };
% listA = {'kitkat.jpg'};

listA = {'rhino1.jpg'};
%listA = {'crochet9.png'};
%listA = {'crochet.png'};
%listA = {'circular_window.png'};
%listA = {'building_us.jpg'};

imparams = { 'img_set', 'dggt', ...
             'img_names', { listA{:} }, ...
             'max_num_cores', 1, ...
             'dr_type','mser', ...
             'res_path','~/cvpr16' };

cache_params = { 'read_cache',true, ...
                 'write_cache',true };

init_dbs(cache_params{:});
cfg = CFG.get(imparams{:});
sqldb = SQL.SqlDb.getObj();
img_set = sqldb.get_img_set(cfg.img_set.img_set, ...
                            cfg.img_set.img_names);
img_metadata = img_set(1);
cid_cache = CASS.CidCache(img_metadata.cid,imparams{:}); 
img = Img('data',cid_cache.get_img(), ...
          'cid',img_metadata.cid, ...
          'url',img_metadata.url);       
cc = [img.height/2 img.width/2];
dr = get_dr(img,cid_cache, ...
                {'type',cfg.dr.dr_type});
[~,drid2] = ismember([dr(:).drid],unique([dr(:).drid]));
tmp = mat2cell(drid2,1,ones(1,numel(drid2)));
[dr(:).drid] = tmp{:};

res = greedy_repeats(dr,cc,'q0',0.0);

keyboard;

T0 = CAM.make_distortion_tform(cc,res.q);
[rimg,T,rb] = IMG.rectify_and_scale(img.data,res.Hinf,T0);

v = LAF.warp_fwd([dr(:).u],T);

figure;
imshow(rimg,rb);
LAF.draw_groups(gca,v,res.G,'PrintLabels',true);