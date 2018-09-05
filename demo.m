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
    bbox_fname = [img_files(k).folder '/' name '_bbox.mat'];
    if exist(bbox_fname)
        load(bbox_fname)
    end
    cc = [(img.width+1)/2 (img.height+1)/2];
    for k2 = 1:numel(name_list)
        
    end
end