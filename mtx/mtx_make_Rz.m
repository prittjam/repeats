%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [Rz] = mtx_make_Rz(phi)
Rz = [ cos(phi)  sin(phi) 0; ...
      -sin(phi)  cos(phi) 0; ...
             0         0  1];