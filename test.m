%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
repeats_init();
img_name = 'cropped_dartboard';
load(['output/' img_name '_H4ql.mat']);
img = Img('url',['data/' img_name '.jpg']);  
cid_cache = CidCache(img.cid, ...
                     { 'read_cache', true, 'write_cache', true });
dr = DR.get(img,cid_cache, ...
                {'type','all', ...
                 'reflection', false });
x = [dr(:).u];
output_all_planes(x,img,model_list);

