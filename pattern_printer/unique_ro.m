%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [rt,is_inverted] = unique_ro(rt)
is_inverted = rt(2,:) < 0;
rt(:,is_inverted) = Rt.invert(rt(:,is_inverted));
