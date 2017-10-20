function [] = test2()
greedy_repeats_init();

% listA = {'226148941_00d29de16b_o.jpg'};
% listA = { 'SY_darts.jpg' };
%listA = { 'wp00a6.png' };
%listA = { 'sett4.jpg' };
% listA = { '2063499388_567bd68634_o.jpg' };
%listA = {'rhino1.jpg'};
listA = {'crochet9.png'};
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
%%%%%
%ex = struct('img_names', {'crochet9.png'}, ...
%            'motion_model', 'Rt');
%%%%
%ex = struct('img_names', {'crochet.png'}, ...
%            'motion_model', 'Rt');
%%%
ex = struct('img_names',  {'kitkat.jpg'}, ...
            'motion_model', 'Rt');            
%%%ex = struct('img_names',  {'EsherA.jpg'}, ...
%            'motion_model', 'Rt');            
%ex = struct('img_names', {'SY_darts.jpg'}, ...
%            'motion_model', 'Rt');
%%%%
%ex = struct('img_names', {'building_us.jpg'}, ...
%            'motion_model', 't');
%%%
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

%ex = struct('img_names', {'cathedral.jpg'}, ...
%            'motion_model', 'Rt');
%%%
%ex = struct('img_names', {'flower1.jpg'}, ...
%            'motion_model', 'Rt');
%%
output_prefix = 'res';

imparams = { 'img_set', 'dggt', ...
             'max_num_cores', 1, ...
             'dr_type','all', ...
             'res_path','~/cvpr16', ...
             'img_names', ex.img_names };
 
cache_params = { 'read_cache', false, ...
                 'write_cache', false };

cfg = CFG.get(imparams{:});

%init_dbs(cache_params{:});

img = Img('url', ...
          '/home/prittjam/src/gtrepeat/dggt/kitkat.jpg'); 

cid_cache = CASS.CidCache(img.cid, ...
                          cache_params{:});
cc = ([img.width img.height]'+1)/2;
gr_params = { 'img', img.data, ...
              'num_planes', 1 };

dr = DR.get(img,cid_cache, ...
                {'type',cfg.dr.dr_type});
dr = group_desc(dr);
[model_list,stats_list] = greedy_repeats(dr,cc,ex.motion_model);

for k = 1:1
    [model_list,stats_list] = greedy_repeats(dr,cc,ex.motion_model);
    for k = 1:numel(model_list)
        rimg= ...
            IMG.render_rectification([dr(:).u],model_list(k),img.data);
        figure;imshow(rimg);
        IMG.output_rectification(img.url,rimg,output_prefix); 
        
%        h = draw_results(img,rimg);    
%        output_reconstruction(img.data,model_list{k}.u_corr, ...
%                              model_list{k},output_prefix);
%        matlab2tikz('figurehandle',gcf, ...
%                    'filename','fig.tex' , ...
%                    'standalone', false);
    
    end
end

%img = Img('url','download2.jpg');       
%cid_cache = CASS.CidCache(img.cid,cache_params{:}); 
[~,name,~] = fileparts(img.url);
save(['res/' name], 'dr','model_list','stats_list','img');
%keyboard;
