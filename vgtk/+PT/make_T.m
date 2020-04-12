%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function T = mtx_make_T(t)
T = [eye(length(t)) t; ...
     zeros(1,length(t)) 1]; 