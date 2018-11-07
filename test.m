%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
repeats_init();

img_name = 'cropped_dartboard';
%img_name = 'pattern1b'
solver = WRAP.lafmn_to_qAl(WRAP.laf222_to_ql);
[res,meas,img] = do_one_img(['data/' img_name '.jpg'], solver);

output_all_planes(meas.x,img,res.model_list);