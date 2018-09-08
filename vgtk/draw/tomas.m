%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [K,Q,D,W,l,qf] = tomas(ax1,C,varargin)
%
%  [K,Q,D,W,l,qf] = ellipse(A)
%
%   Draws the ellipse 
%      x' * K * x = 1
%    corresponding to the positive definite symmetric 2 by 2 matrix 
%    where K = A if A is symmetric; otherwise K = A' * A
%
%  K - symmetric positive definite matrix used
%  Q - orthogonal eigenvectors or principal axes of ellipse
%  D - diagonal matrix with eigenvalues, so K = Q * D * Q'
%  l = 1/sqrt(diag(D)) - lengths of semi-axes of ellipse
%  W = Q*D^(-1/2) - linear transformation mapping unit circle to ellipse
%  qf - string giving quadratic form x'*K*x
%
%  See also ELLIPSOID
%

A = ell_get_TRS_from_C(C);
m = ell_calc_center(C);
t = linspace(0,2*pi,100);
x = A*[cos(t);sin(t);ones(1,length(t))];
hold on;
plot(ax1,m(1),m(2),varargin{:});
plot(ax1,x(1,:),x(2,:),varargin{:});
hold off;

function m = ell_calc_center(C)
c = -[C(end,1:end-1)]';
m = [C(1:end-1,1:end-1)\c;1];

function M = ell_get_TRS_from_C(C)
m = ell_calc_center(C);
T = mtx_make_T(m(1:2));

a1 = mtx_chol_2x22(C(1:2,1:2));
a2 = 

U = [chol(C(1:2,1:2))   zeros(2,1); ...
     zeros(1,2)        1];
M = T*inv(U);
