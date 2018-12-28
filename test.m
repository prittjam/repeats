%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
repeats_init();
%
%img_name = 'cropped_dartboard';
%img_name = 'pattern1b'
%img_name = 'darts'
%img_name = 'tran_1_046'
img_name = 'circletext'
solver = WRAP.lafmn_to_qAl(WRAP.laf222_to_ql);
[model_list,lo_res_list,stats_list,meas,img] = ...
    do_one_img(['data/' img_name '.jpg'], solver);

save(['output/' img_name '.mat'],'model_list', ...
     'lo_res_list','stats_list','meas','img');

output_all_planes(meas.x,img,model_list);