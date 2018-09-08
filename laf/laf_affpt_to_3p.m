%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function lafs = laf_affpt_to_3p(affpt)
lafs = laf_A_to_3p(laf_affpt_to_A(affpt));
