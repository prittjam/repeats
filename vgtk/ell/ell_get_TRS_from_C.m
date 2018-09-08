%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function M = ell_get_TRS_from_C(C)
m = ELL.get__center(C);
T = MTX.make_T(m(1:2));
U = [chol(C(1:2,1:2))   zeros(2,1); ...
     zeros(1,2)        1];
M = T*inv(U);


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
