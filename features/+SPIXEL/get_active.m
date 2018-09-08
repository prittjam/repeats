%
%  Copyright (c) 2018 James Pritts, Denys Rozumnyi
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts and Denys Rozumnyi
%
function [active,BW] = get_active(segments,active)
BW = uint32(ismember(segments,active));
active = BW.*uint32(segments);