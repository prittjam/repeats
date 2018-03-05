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
%ex = struct('img_names',  {'kitkat.jpg'}, ...
%            'motion_model', 'Rt');            
%%%%ex = struct('img_names',  {'EsherA.jpg'}, ...
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
             'res_path','~/cvpr16'};
 
cache_params = { 'read_cache', true, ...
                 'write_cache', true };

cfg = CFG.get(imparams{:});

%init_dbs(cache_params{:});

img = Img('url','img/statehouse.jpg'); 

cid_cache = CASS.CidCache(img.cid, ...
                          cache_params{:});
gr_params = { 'img', img.data, ...
              'num_planes', 1 };
dr = DR.get(img,cid_cache, ...
                {'type','all', ...
                'reflection', false });

cc = [(img.width+1)/2 (img.height+1)/2];

[x,Gsamp,Gapp] = group_desc(dr);


figure;
subplot(1,2,1);
imshow(img.data);
LAF.draw_groups(gca,x,Gapp);
subplot(1,2,2);
imshow(img.data);
LAF.draw_groups(gca,x,Gsamp);

%solver = WRAP.laf1x2_to_lu(cc);
%solver = WRAP.laf1x2_to_qlu(cc); 
%solver = WxRAP.laf1x2_to_qlsu(cc); 
%solver = WRAP.laf2x2_to_qluv(cc); 
%solver = WRAP.laf2x2_to_qlusv(cc); 
%solver = WRAP.laf3x2_to_ql(cc);
%solver = WRAP.laf2x2_to_AHinf(); 
solver = WRAP.lafmxn_to_qAl(WRAP.laf3x2_to_ql(cc));
[model_list,lo_res_list,stats_list,cspond] = ...
    fit_coplanar_patterns(solver,x,Gsamp,Gapp,cc,1);
[~,file_name,ext] = fileparts(img.url);

save(['mat/' file_name '.mat'], ...
     'model_list','stats_list','cspond','x','img');

figure;
imshow(img.data);
for k2 = 1:numel(model_list)
    MM = model_list(k2);
    MM.H = model_list(k2).A;
    MM.H(3,:) = transpose(model_list.l);

    
    xp = LAF.renormI(blkdiag(MM.H,MM.H,MM.H)*LAF.ru_div(x,model_list.cc,model_list.q));
    figure;LAF.draw(gca,xp(:,~isnan(MM.Gs)));
    
    rimg= ...
        IMG.render_rectification(x,MM,img.data, ...
                                 'Registration','Similarity', ...
                                 'extents', ...
                                 [size(img.data,2) size(img.data,1)]');
    figure;
    imshow(rimg);
    keyboard;

    
    figure;
    uimg = IMG.ru_div(img.data,model_list.cc,model_list.q);
    imshow(uimg);
end    
