function [] = test()
greedy_repeats_init();

% listA = {'226148941_00d29de16b_o.jpg'};
% listA = { 'SY_darts.jpg' };
%listA = { 'wp00a6.png' };
%listA = { 'sett4.jpg' };
% listA = { '2063499388_567bd68634_o.jpg' };
%listA = {'rhino1.jpg'};
%listA = {'crochet9.png'};
%listA = {'crochet-011.jpg'};
%listA = { 'calib_prague3.jpg' };

%listA = {'PSWT12.JPG'};

%listA  = {'OLD_rot_001.jpg'};
%listA  = {'wall.jpg'};
%listA = { 'DSC_0810.jpg' }
%listA = { 'fireengine1.jpg' };
% listA = {'liz_taylor.jpg'};
%listA = {'lviv5.jpg'};
%listA = {'img_3303.jpg'}
%listA = { 'prague91.jpg' };
%listA = { 'prague23.jpg' };
%listA = { 'wall.jpg' };
%listA = { 'two_planes.jpg' };
%listA = {'crochet.png'};
%listA = {'crochet9.png'};

%
%ex = struct('img_names', {'circular_window.png'}, ...
%            'motion_model', 'Rt');
%%%%
%ex = struct('img_names', {'crochet9.png'}, ...
%            'motion_model', 'Rt');
%%%
%ex = struct('img_names', {'crochet.png'}, ...
%            'motion_model', 'Rt');
%
%ex = struct('img_names',  {'kitkat.jpg'}, ...
%            'motion_model', 'Rt');            
%ex = struct('img_names',  {'EsherA.jpg'}, ...
%            'motion_model', 'Rt');            
%%ex = struct('img_names', {'SY_darts.jpg'}, ...
%            'motion_model', 'Rt');
%%
%ex = struct('img_names', {'building_us.jpg'}, ...
%            'motion_model', 't');
%%
%ex = struct('img_names', {'minnesota-tennis-courts-aerial.jpg'}, ...
%            'motion_model', 't');
%%
%ex = struct('img_names', {'object0149.view01.png'}, ...
%            'motion_model', 't');
%
%ex = struct('img_names', {'prague71.jpg'}, ...
%            'motion_model', 't');
%
%ex = struct('img_names', {'calib_prague21.jpg'}, ...
%            'motion_model', 't');
%
%ex = struct('img_names', {'calib_prague29.jpg'}, ...
%            'motion_model', 't');

ex = struct('img_names', {'cathedral.jpg'}, ...
            'motion_model', 'Rt');

imparams = { 'img_set', 'dggt', ...
             'max_num_cores', 1, ...
             'dr_type','all', ...
             'res_path','~/cvpr16', ...
             'img_names', ex.img_names };
 
cache_params = { 'read_cache', true, ...
                 'write_cache', true };

init_dbs(cache_params{:});
cfg = CFG.get(imparams{:});

sqldb = SQL.SqlDb.getObj();
img_set = sqldb.get_img_set(cfg.img_set.img_set, ...
                            cfg.img_set.img_names);
img_metadata = img_set(1);
cid_cache = CASS.CidCache(img_metadata.cid, cache_params{:});
img = Img('data',cid_cache.get_img(), ...
          'cid',img_metadata.cid, ...
          'url',img_metadata.url);       

dr = get_dr(img,cid_cache, ...
                {'type',cfg.dr.dr_type});

gr_params = { 'desc_linkage', 'single', ...
              'desc_cutoff', 160,... 
              'cc', [img.width/2 img.height/2], ...
              'img', img.data, ...
              'motion_model', ex.motion_model, ...
              'num_planes', 1 };

[model_list,u_corr_list,stats_list] = greedy_repeats(dr,gr_params{:});

for k = 1:numel(model_list)
    [rimg,ud_img] = IMG.render_rectification([dr(:).u],u_corr_list{k}, ...
                                             model_list{k},img);
    IMG.output_rectification(img,rimg,ud_img);
    h = draw_results(img,rimg);    
    draw_reconstruction(h(1),u_corr_list{k},model_list{k});
end

%img = Img('url','download2.jpg');       
%cid_cache = CASS.CidCache(img.cid,cache_params{:}); 
