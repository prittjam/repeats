%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function H = hg_2elin(C1a, C2a, C1b, C2b)

% function H = hg_2elin(C1a, C2a, C1b, C2b)
% correspondences: C1a <-> C1b, C2a <-> C2b.
%
% INPUT
%  Four real symmetric nonsingular 3x3 matrices:
%    C1a, C2a - the conic coefficient matrices in the first view
%    C1b, C2b - the corresponding conics in the second view
%
% For more details see  Chum, Matas ICPR 2012:.
% Homography Estimation from Correspondences of Local Elliptical Features
%
% (C) Ondra Chum 2012


N1 = inv(C2A(C1a));
D1 = C2A(C1b);
N2 = inv(C2A(C2a));
D2 = C2A(C2b);

H = A2toRH (N1, D1, N2, D2);
