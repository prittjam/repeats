%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function m = get_center(C)
c = -[C(end,1:end-1)]';
m = [C(1:end-1,1:end-1)\c;1];