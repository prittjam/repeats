function [] = demo(img_files,solver_list,name_list)
repeats_init();
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
            res = rectify_scene_planes(x,Gsamp,Gapp,solver_list{k2},cc);
            save(target_fname, 'x','Gsamp','Gapp' ...
                 '-struct', 'res', '-struct', img) ;

        end
    end
end