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
%img_path = 'data/beer.jpg';
%img_path = 'download'
%img_path = 'img'
%img_path = 'raw'
%img_path = 'cards'
%img_path = 'small'
%img_path = 'data/fairey.jpg';
%img_path = 'pavement'
%img_path = 'coke'
%img_name = 'fisheye'
%img_path = 'data/circles.jpg';
%img_path = 'data/cropped_dartboard.jpg';
%img_path = 'data/Fujifilm_X_E1_Samyang_8mm.jpg';
%img_path = 'data/pami19/canon_eos_5d_15mm/0.jpg'
%img_path =
%img_path = 'data/new_medium_63_o.jpg'
%img_path = 'data/pami19/samyang_7.5mm/10.jpg'
%img_path = 'data/niceone.jpg';
%img_path = 'data/fairey5.jpg';
%img_path = 'data/empire.jpg';
%img_path = 'data/church.jpg'
%img_path = 'data/green_portal.jpg'
%img_path = 'data/big_church.jpg'
%img_path = 'data/prague.jpg'
%img_path = 'data/pami19/Samyang_f8mm/34.jpg';
%img_path = 'data/pami19/Panasonic_DMC_GM5-Samyang_7.5_mm_UMC_Fish_eye_MFT-f7.5/39.jpg';
%img_path = 'data/pami19/Olympus_E_M1-f_unknow/43.jpg';
%img_path = 'data/pami19/Nikon_D7000-10.5mm-f10.5mm-fe3516mm_shotwideopen/45.jpg';
%img_path = 'data/pami19/Nikon_D7000-10.5mm-f10.5mm-fe3516mm_shotwideopen/44.jpg';
%img_path = ['/home/jbpritts/Desktop/data/pami19/Pentax_K5-' ...
%            'PENTAX_DA_FISH-EYE_10-17mm-f10mm/35.jpg'];
%img_path = 'data/pami19/canon_eos_30d_10mm/4.jpg'
%img_path = 'data/red_portal.jpg';
%img_path = 'data/china.jpg' 
%img_path = 'data/vittorio.jpg' 
%img_path = 'data/soup.jpg' 
%img_path = 'data/montreal.jpg' 
%img_path = 'data/stars.jpg' 
%img_path = 'data/sunny.jpg';
%img_path = 'data/pentax.jpg';
%img_path = 'data/pami19/Canon_EOS_REBEL_T2i-Samyang_8mm-f8mm/50.jpg'
%img_path = '/home/jbpritts/src/repeats/data/pami19/GoPro_Hero4_7med/62.jpg';
%img_path = '/home/jbpritts/src/repeats/data/pami19/sigma_15mm/12.jpg'
%img_path = ['/home/jbpritts/src/repeats/data/pami19/samyang_7.5mm/42.jpg']
%img_path = 'data/pami19/Pentax_K3-PENTAX_DA_FISH-EYE_10-17mm-f10mm/36.jpg'
%img_path = 'data/pami19/Panasonic_DMC-GM5_Samyang7.5mm_f3.5_fishey-f7.5mm-3/37.jpg'
%img_path = 'data/oblique_fairey.jpg'
%img_path = '/home/jbpritts/src/repeats/data/pami19/Olympus_E_M1-f_unknow/43.jpg'
%img_path = 'data/china.jpg'
%img_path = 'data/castle.jpg';
%img_path = 'data/flatiron.jpg';
%img_path = 'data/port.jpg';
%img_path = 'data/china2.jpg'
%img_path = 'data/rotunda.png'
%img_path = '/home/jbpritts/src/repeats/results/WRAP.laf2_to_ql/20191020_112921/green_portal.mat'
%img_path = 'data/downtown.jpg'
%img_path = 'data/GOPR0186.JPG';
%img_path = 'data/oldtown.JPG';
%img_path = 'data/arch.jpg';
%img_path = 'data/sanpedro.jpg';
%img_path = 'data/milan6.jpg'
%img_path = 'data/casa_Bezos.jpg'
%img_path = 'data/tv.jpg'
%img_path = 'data/barrels.jpg'
%img_path = '/home/jbpritts/Documents/pami19/suppimg/cool_building.jpg';

img_path = '/home/jbpritts/Downloads/wide_pattern2.jpg';

dt = datestr(now,'yyyymmdd_HHMMSS');

repeats_init();

solver = WRAP.lafmn_to_qAl(WRAP.laf22_to_qluv(), ...
                           'upgrade_fn', @laf2_to_Amur);

results_path = fullfile('results',class(solver.solver_impl),dt);

ransac_settings = ...
    { 'min_trial_count', 350, ...
      'max_trial_count', 350, ...
      'reprojT', 12 } ;

dr_settings = ...
    { 'desc_cutoff', 150 }; 

model_settings = ...
    { 'motion_model', 't' };

varargin = { ransac_settings{:} dr_settings{:} model_settings{:} };
[model_list,res_list,stats_list,meas,img] = ...
    do_one_img(img_path,solver,varargin{:});

save_results(results_path,img_path,dt,model_list, ...
             res_list,stats_list,meas,img);

render_settings =  ...
    { 'min_scale', 1e-5, ...
      'max_scale', 40, ...
      'Registration', 'Affinity' };

[uimg,rimg,rd_div_line_img] = ...
    render_imgs(img.data,meas,model_list(1),res_list(1),...
                render_settings{:});

save_imgs(results_path,img_path,uimg,rimg,rd_div_line_img,[]);