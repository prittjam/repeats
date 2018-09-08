%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function s = laf_is_reflected(u)
sc = laf_get_scale(u);
s = sc < 0;