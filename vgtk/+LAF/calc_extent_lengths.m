%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function d = calc_extent_lengths(u)
d = [sqrt(sum((u(1:2,:)-u(4:5,:)).^2)); ...
     sqrt(sum((u(7:8,:)-u(4:5,:)).^2))];