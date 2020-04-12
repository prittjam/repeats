%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function has = has_laf_update(key)
has = ~isempty(strfind(key,'LAF.CFG.laf'));