%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function d = calc_extent_lengths(u)
x = LAF.renormI(u);
d = [sqrt(sum((x(1:2,:)-x(4:5,:)).^2)); ...
     sqrt(sum((x(7:8,:)-x(4:5,:)).^2))];