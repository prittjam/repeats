%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function A = C2A(C)

% function A = C2A(C)
% for elliptical conics C, C2A returns an affine transformation
% that transforms a unit circle to the ellipse
% (set-wise, ie ambiguity in rotation)
%
% (C) Ondra Chum 2012

C = inv(C);
C = -C ./ C(3,3);

A = eye(3);

A(1,3) = -C(3,1);
A(2,3) = -C(2,3);
A(1,1) = sqrt(C(1,1) + A(1,3)^2);
A(2,1) = (C(1,2) + A(1,3) * A(2,3)) / A(1,1);
A(2,2) = sqrt(C(2,2) + A(2,3)^2 -A(2,1)^2);
