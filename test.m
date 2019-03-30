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
repeats_init();
solver = WRAP.lafmn_to_qAl(WRAP.laf222_to_ql);
[model_list,res_list,stats_list,meas,img] = do_one_img(img_path,solver);
dt = datestr(now,'yyyymmdd_HHMMSS');
load('output/cropped_dartboard.mat');
save_results(img_path,dt,model_list, ...
             res_list,stats_list,meas,img);