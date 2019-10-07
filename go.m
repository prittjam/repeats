%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
%img_name = 'pavement'
%img_name = 'darts'
%img_name = 'tran_1_046'
%img_path = 'circletext'
%img_path = 'nyu_test3'
%img_path = 'data/pattern24w.jpg'
%img_path = 'download'
%img_path = 'img'
%img_path = 'raw'
%img_path = 'cards'
%img_path = 'small'
%img_path = 'data/pattern1b.jpg';
%img_path = 'pavement'
%img_path = 'coke'
%img_name = 'fisheye'
%img_path = 'data/circles.jpg';
%img_path = 'data/barrels.jpg';
%img_path = 'data/cropped_dartboard.jpg';
img_path = 'data/Fujifilm_X_E1_Samyang_8mm.jpg';
%img_path =
%'/home/jbpritts/Downloads/data/fisheye/Nikon_D7000-10.5mm-f10.5mm-fe3516mm_shotwideopen.jpg';
%img_path = 'data/new_medium_63_o.jpg'

%img_path = '~/Desktop/veggies.jpg';

dt = datestr(now,'yyyymmdd_HHMMSS');

repeats_init();

solver = WRAP.lafmn_to_qAl(WRAP.laf2_to_ql);

results_path = fullfile('results',class(solver.solver_impl),dt);

ransac_settings = ...
    { 'min_trial_count', 100, ...
      'max_trial_count', 100, ...
      'reprojT', 15 } ;

dr_settings = ...
    { 'desc_cutoff', 150 }; 

model_settings = ...
    { 'motion_model', 'Rt' };

varargin = { ransac_settings{:} dr_settings{:} model_settings{:} };
[model_list,res_list,stats_list,meas,img] = ...
    do_one_img(img_path,solver,varargin{:});

save_results(results_path,img_path,dt,model_list, ...
             res_list,stats_list,meas,img);

render_settings =  ...
    { 'min_scale',1e-5, 'max_scale',15 };

[uimg,rimg,rd_div_line_img] = ...
    render_imgs(img.data,meas,model_list(1),res_list(1),...
                render_settings{:});

save_imgs(results_path,img_path,uimg,rimg,rd_div_line_img,[]);