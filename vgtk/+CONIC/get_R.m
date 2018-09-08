%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function M = get_R(C)
Q=takagi(C(1:2,1:2));

% Lanczos tridiagonalization using modified partial orthogonalization
% and restart
function [Q,S] = takagi(A)
[a,b,Q1,nSteps,nVec] = LanMPOR(A,rand(n,1),nSteps);
[s,Q2] = CSSVD(a, b);		% pure QR 
Q = Q1*Q2;

% svd of tridiagonal 
%if (svd_selection == 1)
%    [s,Q2] = CSSVD(a, b);		% pure QR 
%elseif (svd_selection == 2)
%    [s,ifail,Q2] = cstsvdd(a, b);	% divide-and-conquer
%else
%    [s,Q2] = cstsvdt(a, b);             % twisted factorization
%end
