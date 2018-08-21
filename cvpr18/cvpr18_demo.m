function [] = cvpr18_demo(img_path)
repeats_init();
cache_params = { 'read_cache', true, ...
                 'write_cache', true };

%file_pattern_list{1} = fullfile(img_path, 'building_us.jpg');
%file_pattern_list{1} = fullfile(img_path,'tran_1_046.jpg');
%
file_pattern_list{1} = fullfile(img_path,'*.jpg');
file_pattern_list{2} = fullfile(img_path,'*.png');
file_pattern_list{3} = fullfile(img_path,'*.JPG');

img_files = [];
for k = 1:numel(file_pattern_list)
    img_files = cat(1,img_files,dir(file_pattern_list{k}));    
end

name_list = { 'H2.5qlu', 'H3qlsu', 'H3.5qluv', 'H4qlusv' };
solver_list = {@WRAP.laf2_to_qlu, ...
               @WRAP.laf2_to_qlsu, ...
               @WRAP.laf22_to_qluv, ...
               @WRAP.laf22_to_qlusv};

[cur_path, name, ext] = fileparts(mfilename('fullpath'));

for k = 1:numel(img_files)
    dr = [];
    border = [];
    target_dir = [cur_path '/output/'];
    if ~exist(target_dir)
        mkdir(target_dir);
    end
    [~,name,ext] = fileparts(img_files(k).name);
    img = Img('url', ...
              [img_files(k).folder '/' img_files(k).name]);  
    bbox_fname = [img_files(k).folder '/' name '_bbox.mat'];
    if exist(bbox_fname)
        load(bbox_fname)
    end
    cc = [(img.width+1)/2 (img.height+1)/2];
    cid_cache = CASS.CidCache(img.cid,cache_params{:});

    for k2 = 1:numel(name_list)
        target_fname = [target_dir name '_' name_list{k2} '.mat'];
        if ~exist(target_fname)
            if isempty(dr)
                dr = DR.get(img,cid_cache, ...
                                {'type','all', ...
                                 'reflection', false });
                [x,Gsamp,Gapp] = group_desc(dr);    
            end
            
            solver = WRAP.lafmn_to_qAl(feval(solver_list{k2},cc));
            [model_list,lo_res_list,stats_list,cspond] = ...
                fit_coplanar_patterns(solver,x, ...
                                      Gsamp,Gsamp,cc,1);
            tmp = img;
            img = img.data;

            save(target_fname, ...
                 'model_list','lo_res_list','stats_list', ...
                 'cspond','x','Gsamp','Gapp','img');
            img = tmp;

            %            [rimg,uimg] = render_results(img.data,model_list);
            
%            model_list(1).H = model_list(1).A;
%            model_list(1).H(3,:) = transpose(model_list(1).l);
%
%            imwrite(rimg, ...
%                    [target_dir name '_' name_list{k2} '_rect.jpg']);
%            imwrite(uimg, ...
%                    [target_dir name '_' name_list{k2} '_ud.jpg']);
%
        end
    end
end
