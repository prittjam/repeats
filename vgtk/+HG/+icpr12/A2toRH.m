%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function H = A2toRH (N1, D1, N2, D2)

% function H = A2toRH (N1, D1, N2, D2)
%
% computes homography H from two ellipse-to-ellipse correspondences
% N1, N2 are 3x3 matrices representing affine transformations normalizing
%   ellipses in the first image to unit circles
% D1, D2 are 3x3 matrices representing affine transformations de-normalizing
%   unit circles to ellipses in the second image
%
% For more details see  Chum, Matas ICPR 2012:.
% Homography Estimation from Correspondences of Local Elliptical Features
%
% (C) Ondra Chum 2012

do_norm = 1;

iN1 = inv(N1); iN2 = inv(N2);
u1 = [iN1(:,3); D1(:,3)];
u2 = [iN2(:,3); D2(:,3)];

if do_norm
  [T1, iT1] = normpts(u1(1:3),u2(1:3));
  u1(1:3) = T1 * u1(1:3);
  u2(1:3) = T1 * u2(1:3);
  N1 = N1 * iT1;
  N2 = N2 * iT1;

  [T2, iT2] = normpts(u2(4:6),u1(4:6));
  u1(4:6) = T2 * u1(4:6);
  u2(4:6) = T2 * u2(4:6);
  D1 = T2 * D1;
  D2 = T2 * D2;
end

Z1 = [getZ(u1), nd(D1,N1), zeros(7,3)];
Z2 = [getZ(u2), zeros(7,3), nd(D2,N2)];
Z = [Z1; Z2];

[u, d, v] = svd(Z);
H = reshape(v(1:9,end), 3, 3)';

if do_norm
  H = iT2 * H * T1;
end


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


function Z = nd(A,B)
A = A'; B = B';

Z(:,3) = [0; 0; A(3);
          0; 0; A(6); 1];

Z(:,1) = [A(2)*B(1)-A(1)*B(4); A(2)*B(2)-A(1)*B(5);
          A(2)*B(3)-A(1)*B(6); A(5)*B(1)-A(4)*B(4);
          A(5)*B(2)-A(4)*B(5); A(5)*B(3)-A(4)*B(6); 0];

Z(:,2) = [A(1)*B(1)+A(2)*B(4); A(1)*B(2)+A(2)*B(5);
          A(1)*B(3)+A(2)*B(6); A(4)*B(1)+A(5)*B(4);
          A(4)*B(2)+A(5)*B(5); A(4)*B(3)+A(5)*B(6); 0];


function [T, iT] = normpts(u1,u2)
m = (u2 + u1) / 2;
d = (u1 - u2) / 2;
sc = sqrt(d(1).^2 + d(2).^2);
if sc < 1
  sc = 1;
end

iT = [sc 0 m(1)
      0 sc m(2)
      0  0  1];

sc = 1 / sc;

T = [sc 0 -m(1)*sc
     0 sc -m(2)*sc
     0  0  1];
