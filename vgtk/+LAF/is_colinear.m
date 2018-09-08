%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function flag = is_colinear(u,T)
flag = PT.are_colinear(u(4:6,:),T);