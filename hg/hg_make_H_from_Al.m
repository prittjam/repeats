%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function H = hg_make_H_from_Al(A,l)
Hinf = eye(3);
Hinf(3,:) = l';
H = A*Hinf;