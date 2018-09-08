%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function A = inormu(ic);

%INORMU - normalisation by affine transformation
%    function A = inormu(ic);
%    moves ic into origin and scale by (not sure what yet :)

sc = 1/ (2*sum(ic));
A = diag([sc, sc, 1]) * [1 0 -ic(1); 0 1 -ic(2); 0 0 1];


