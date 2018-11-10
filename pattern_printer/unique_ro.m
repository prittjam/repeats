%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function is_inverted = unique_ro(rt)
is_inverted = squeeze(rt(1,3,:) < 0);