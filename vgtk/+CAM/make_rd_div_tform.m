%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function T = make_rd_div_tform(cc,q)
T = maketform('custom',2,2, ...
              @CAM.rd_div_tform, ...
              @CAM.ru_div_tform, ...
              struct('cc',cc,'q',q));
