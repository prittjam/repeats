function [] = test()
greedy_repeats_init();
%ex = struct('img_names','OLD_rot_001.jpg', ...
%            'motion_model', 'Rt');
%ex = struct('img_names', {'circular_window.png'}, ...
%            'motion_model', 'Rt');
%%%%%%%%%%%%%
%ex = struct('img_names', {'crochet9.png'}, ...
%            'motion_model', 'Rt');
%%%%%%%%%
% ex = struct('img_names', {'crochet.png'}, ...
%            'motion_model', 'Rt');
%%%%%%%%
ex = struct('img_names',  {'kitkat.jpg'}, ...
            'motion_model', 'Rt');            
%ex = struct('img_names',  {'EsherA.jpg'}, ...
%            'motion_model', 'Rt');            
%%ex = struct('img_names', {'SY_darts.jpg'}, ...
%            'motion_model', 'Rt');
%%%%%%%%%%%%%
%ex = struct('img_names', {'building_us.jpg'}, ...
%            'motion_model', 't');
%%%%%%
%ex = struct('img_names', {'minnesota-tennis-courts-aerial.jpg'}, ...
%            'motion_model', 't');
%%
%ex = struct('img_names', {'object0149.view01.png'}, ...
%            'motion_model', 't');
%%%
%ex = struct('img_names', {'prague71.jpg'}, ...
%            'motion_model', 't');
%
%ex = struct('img_names', {'calib_prague21.jpg'}, ...
%            'motion_model', 't');
%
%ex = struct('img_names', {'calib_prague29.jpg'}, ...
%            'motion_model', 't');

%ex = struct('img_names', {'cathedral.jpg'}, ...
%            'motion_model', 'Rt')
%%%ex = struct('img_names', {'wall.jpg'}, ...
%            'motion_model', 'Rt');
%
%ex = struct('img_names', {'fairey2.png'}, ...
%            'motion_model', 'Rt');
%%%
%%%%
%%
output_prefix = 'res';

imparams = { 'img_set', 'dggt', ...
             'max_num_cores', 1, ...
             'dr_type','all', ...
             'res_path','~/cvpr16', ...
             'img_names', ex.img_names };

cache_params = { 'read_cache', true, ...
                 'write_cache', true };

cfg = CFG.get(imparams{:});

init_dbs(cache_params{:});
sqldb = SQL.SqlDb.getObj();
img_set = sqldb.get_img_set(cfg.img_set.img_set, ...
                            cfg.img_set.img_names);
img_metadata = img_set(1);
cid_cache = CASS.CidCache(img_metadata.cid, cache_params{:});
img = Img('data',cid_cache.get_img(), ...
          'cid',img_metadata.cid, ...
          'url',img_metadata.url);       

cc = ([img.width img.height]'+1)/2;

dr = DR.get(img,cid_cache, ...
                { 'type',cfg.dr.dr_type, ...
                  'reflection', true });
dr = group_desc(dr);

figure;imshow(img.data);
[model_list,stats_list] = greedy_repeats(dr,cc,ex.motion_model);

for k = 1:numel(model_list)
    [rimg,ud_img] = ...
        IMG.render_rectification([dr(:).u],model_list(k),img.data);
    figure;imshow(rimg);
    %    IMG.output_rectification(img.data,rimg,ud_img,output_prefix);
    %    h = draw_results(img,rimg);    
%    imshow(img.data);
%    output_reconstruction(img.data,model_list{k}.u_corr, ...
%                          model_list{k},output_prefix);
%    %    matlab2tikz('figurehandle',gcf, ...
    %                'filename','fig.tex' , ...
    %                'standalone', false);
end

%img = Img('url','download2.jpg');       
%cid_cache = CASS.CidCache(img.cid,cache_params{:}); 
[~,name,~] = fileparts(img.url);
save(['res/' name], 'dr','model_list','stats_list','img');
%keyboard;
