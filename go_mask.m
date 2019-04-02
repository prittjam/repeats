%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%

img_path = 'data/cropped_dartboard.jpg';

dt = datestr(now,'yyyymmdd_HHMMSS');

repeats_init();

solver = WRAP.lafmn_to_qAl(WRAP.laf222_to_ql);

results_path = fullfile('results',class(solver.solver_impl),dt);

ransac_settings = ...
    { 'min_trial_count', 750, ...
      'max_trial_count', 750, ...
      'reprojT', 7 } ;

dr_settings = ...
    { 'desc_cutoff', 150 }; 

varargin = { ransac_settings{:} dr_settings{:} };
[model_list,res_list,stats_list,meas,img] = ...
    do_one_img(img_path,solver,varargin{:});

save_results(results_path,img_path,dt,model_list, ...
             res_list,stats_list,meas,img);

[uimg,rimg,sc_img] = ...
    render_imgs(img.data,meas,model_list(1),res_list(1),...
                'min_scale',0.05, 'max_scale',15);

mask = imread('data/cropped_dartboard_mask.png');
masked_sc_img = IMG.render_masked_scale_change(img.data,meas, ...
                                               model_list(1),res_list(1),mask);

keyboard;
save_imgs(results_path,img_path,uimg,rimg,sc_img,masked_sc_img);