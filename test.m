%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
%img_name = 'pavement'
%img_name = 'darts'
%img_name = 'tran_1_046'
%img_name = 'circletext'
%img_name = 'nyu_test3'
%uimg_name = 'new_medium_63_o'
%img_name = 'pattern24w'
%img_name = 'download'
%img_name = 'img'
%img_name = 'raw'
%img_name = 'cards'
%img_name = 'small'
%img_name = 'pattern1b';
%img_name = 'pavement'
%img_name = 'coke'
%img_name = 'fisheye'

img_path = 'data/cropped_dartboard.jpg';
%img_path = 'data/circles.jpg';

dt = datestr(now,'yyyymmdd_HHMMSS');
results_path = fullfile('results',class(solver.solver_impl),dt);

repeats_init();

%solver = WRAP.lafmn_to_qAl(WRAP.laf22_to_ql);
solver = WRAP.lafmn_to_qAl(WRAP.laf222_to_ql);

ransac_settings = ...
    { 'min_trial_count', 500, ...
      'max_trial_count', 500, ...
      'reprojT', 15 } ;

dr_settings = ...
    { 'desc_cutoff', 150 }; 

varargin = { ransac_settings{:} dr_settings{:} };
[model_list,res_list,stats_list,meas,img] = ...
    do_one_img(img_path,solver,varargin{:});


save_results(results_path,img_path,dt,model_list, ...
             res_list,stats_list,meas,img);

[uimg,rimg,sc_img] = ...
    render_images(img.data,meas,model_list(1),res_list(1),...
                  'min_scale',0.05, 'max_scale',20);

save_imgs(results_path,img_path,uimg,rimg,sc_img);