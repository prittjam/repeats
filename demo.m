%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = demo(img_files,solver_list,varargin)
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
    for k2 = 1:numel(solver_list)
        res = do_one_img(img_files(k).name, ...
                         'solver', solver_list{k2}, ...
                         varargin{:});
    end
end