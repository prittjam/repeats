%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [A,sc] = make_fitz_normalization(cc)
     display("CAM.make_fitz_normalization(cc) is deprecated. New call format: CAM.make_norm_xform('norm_type','fitz','norm_params',cc)");
     sc = sum(2*cc);
     ncc = -cc/sc;
     A = [1/sc 0        ncc(1); ...
          0       1/sc  ncc(2); ...
          0       0      1];
end