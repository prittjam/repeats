function [] = cvpr14_demo()
repeats_init();
cache_params = { 'read_cache', false, ...
                 'write_cache', false };
listing = dir('input/*.jpg');

name_list = { 'H4ls' };
solver_list = { @WRAP.laf2_to_qlu };
               
[cur_path, name, ext] = fileparts(mfilename('fullpath'));

for k = 1:numel(listing)
    dr = [];
    border = [];
    target_dir = [cur_path '/output/'];
    if ~exist(target_dir)
        mkdir(target_dir);
    end
    [~,name,ext] = fileparts(listing(k).name);
    img = Img('url', ...
              [listing(k).folder '/' listing(k).name]);  
    bbox_fname = [listing(k).folder '/' name '_bbox.mat'];
    if exist(bbox_fname)
        load(bbox_fname)
    end
    cc = [(img.width+1)/2 (img.height+1)/2];
    cid_cache = CASS.CidCache(img.cid,cache_params{:});

    for k2 = 1:numel(name_list)
        target_fname = [target_dir name '_' name_list{k2} '.mat'];
        if ~exist(target_fname)
            %            try
                if isempty(dr)
                    dr = DR.get(img,cid_cache, ...
                                    {'type','all', ...
                                     'reflection', false });       
                    [x,Gsamp,Gapp] = group_desc(dr);    
                end

                solver = WRAP.lafmn_to_qAl(feval(solver_list{k2},cc));
                [model_list,lo_res_list,stats_list,cspond] = ...
                    fit_coplanar_patterns(solver,x,Gsamp,Gsamp,cc,1);
                tmp = img;
                img = img.data;
                save(target_fname, ...
                     'model_list','lo_res_list','stats_list', ...
                     'cspond','x','Gsamp','Gapp','img');
                img = tmp;

                model_list(1).H = model_list(1).A;
                model_list(1).H(3,:) = transpose(model_list(1).l);
                if ~isempty(border)
                    rimg = IMG.render_rectification(x,model_list(1),img.data, ...
                                                    'Registration','none', ...
                                                    'extents',...
                                                    [size(img.data,2) size(img.data,1)]', ...
                                                    'bbox',border);
                else
                    rimg = IMG.render_rectification(x,model_list(1),img.data, ...
                                                    'Registration','none', ...
                                                    'extents',...
                                                    [size(img.data,2) size(img.data,1)]');
                end

                imwrite(rimg,[target_dir name '_' name_list{k2} ...
                              '_rect.jpg']);
                
                uimg = IMG.ru_div(img.data,model_list.cc, ...
                                  model_list.q ,...
                                  'extents', 2*[size(img,2) size(img,1)]');

                imwrite(uimg, ...
                        [target_dir name '_' name_list{k2} '_ud.jpg']);
%           catch err
%               keyboard;
%           end
        end
    end
end
