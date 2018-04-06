function [] = test()
%listA = {'building_us.jpg'};
%listA = {'rhino1.jpg'};
%listA = { 'fireengine1.jpg' };
%listA = {'134509092_4e69559100_o.jpg'};
%listA = {'Transamerica_Pyramid_top.jpg'};
%listA = {'img_9541.jpg'};
%listA = {'cathedral.jpg'};
%listA = {'two_planes.jpg'};
%listA = {'ostrava.jpg'};
%listA = {'img_3303.jpg'};
%listA = {'checkerboard.jpg'};
%listA = {'templehof11.jpg'};
%%
%ex_list(1) = struct('img_name', 'building_us.jpg', ...
%                    'img_set', 'dggt');
%
%%%%%
%ex_list(1) = struct('img_name', 'GOPR0181.JPG', ...
%                    'img_set', 'Hero 4 Black/tyn/scaled50');
%%%%%%%%
%ex_list(1) = struct('img_name', 'GOPR0416.png', ...
%                    'img_set', 'Hero 4 Black/rotunda');
%
%%%%%%%%

%ex_list(1) = struct('img_name', 'GOPR0186.JPG', ...
%                    'img_set', 'Hero 4 Black/scorner/scaled30');
%%%
%%%

%ex_list(1) = struct('img_name', 'DSC_2157.JPG', ...
%                    'img_set', 'Hero 4 Black/zderaz');
%%%
%%%%%%%
%ex_list(1) = struct('img_name', 'building_us.jpg', ...
%                    'img_set', 'dggt');
%%%%%ex_list(1) = struct('img_name', 'fireengine1.jpg' , ...
%%                    'img_set','dggt');
%
%
%ex_list(1) = struct('img_name', 'rhino1.jpg', ...
%                    'img_set','dggt');
%
%ex_list(1) = struct('img_set','dggt', ...
%                    'img_name', 'fairey2.png');
%
   %
%ex_list(1) = struct('img_set','dggt', ...
%                    'img_name', 'EsherA.jpg');
%%%%%%%

%ex_list(1) = struct('img_name', 'GOPR0383.png', ...
%                    'img_set', 'Hero4B/rotunda');
%%%

%ex_list(1) = struct('img_name', 'SY_darts.jpg' , ...
%                    'img_set', 'dggt');
%%
%%%ex_list(1) = struct('img_names', {'cathedral.jpg'}, ...
%                    'motion_model', 'Rt');
%%
%ex_list(1) = struct('img_name', 'kitkat.jpg', ...
%                    'img_set', 'dggt');
%%
%ex_list(1) = struct('img_name', 'cathedral.jpg', ...
%                    'img_set', 'dggt');
%
%%%
greedy_repeats_init('..');

imparams = { 'img_set', ex_list.img_set, ...
             'max_num_cores', 1, ...
             'res_path','~/cvpr16', ...
             'img_names', { ex_list.img_name } };
 
cache_params = { 'read_cache', true, ...
                 'write_cache', false };

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

dr = DR.get(img,cid_cache, {'type','all', ...
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
%solver = WRAP.laf1x2_to_qlsu(cc); 
%solver = WRAP.laf2x2_to_qluv(cc); 
%solver = WRAP.laf2x2_to_qlusv(cc); 
%solver = WRAP.laf3x2_to_ql(cc);
%solver = WRAP.lafmxn_to_qAl(WRAP.laf3x2_to_ql(cc));
%solver = WRAP.laf2x2_to_AHinf();

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
    rimg = IMG.render_rectification(x,MM,img.data, ...
                                    'Registration','Similarity', ...
                                    'extents', ...
                                    [size(img.data,2) size(img.data,1)]');
    figure;
    imshow(rimg);
    figure;
    uimg = IMG.ru_div(img.data,model_list.cc,model_list.q);
    imshow(uimg);
end    
