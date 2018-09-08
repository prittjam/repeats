%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function H = A2toH (A1, u1, A2, u2)

% function H = A2toH (A1, u1, A2, u2)
%
% computes homography H from known affine approximations A1 and A2
% in two disticnt points (in the first image) u1 and u2
% A1, A2 are 3x3 matrices representing the affine transformations
% u1, u2 are 3x1 homogenous vectors
%
% For more details see  Chum, Matas ICPR 2012: 
% Homography Estimation from Correspondences of Local Elliptical Features
%
% (C) Ondra Chum 2012

Z1 = [getZ(u1), trA(A1), zeros(7,1)];
Z2 = [getZ(u2), zeros(7,1), trA(A2)];
Z = [Z1; Z2];

[u, d, v] = svd(Z);
r = v(:,end);
H = reshape(r(1:9), 3, 3)';

function Z = trA(A)
Z = [A(1,:)'; A(2,:)'; A(3,3)];

function Z = getZ(u)

Z = zeros(7,9);
Z(1,[1,7]) = [-1, u(4)];
Z(2,[2,8]) = [-1, u(4)];
Z(3,[3,7,8]) = [-1, -u(1)*u(4), -u(2)*u(4)];
Z(4,[4,7]) = [-1, u(5)];
Z(5,[5,8]) = [-1, u(5)];
Z(6,[6,7,8]) = [-1, -u(1)*u(5), -u(2)*u(5)];
Z(7,[9,7,8]) = [-1, -u(1), -u(2)];
