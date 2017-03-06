function w = lp_vq(K)
%LP_VQ Linear Programming Vector Quantization
%   Detailed explanation goes here
gamma = 1./sum(K,2);
    
% l : # of data points
l = size(K,1);
l2 = 2*l;

% let the optimization solution be x = [a_1 ; ... ; a_l ; b_1 ; ... ; b_l],
%  x is of dim 2l.

% function f to minimize is: f(a,b) = g_1*a_1 +g_2*a_2 + ... + g_l*a_l +
%                                     + g_1*b_1 + ... + g_l*b_l 
%                        so  f(x) = g_1*x_1 +g_2*x_2 + ... + g_l*x_l +
%                                     + g_1*x_(l+1) + ... + g_l*x_(2l)
%  so the coefficients are f =[g_1 ; g_2 ; ... ; g_l ; g_1 ; g_2 ; ... g_l]
f = [gamma ; gamma];

% the equations K(a-b)>=1 can be written - K*a + K*b <= -1
% so the matrix of the lhs of the l equations coefficients are:
A = [-K  K];
% and their rhs:
b = (-1)*ones(l,1);

% also the lower bound of every dim of x must be 0:
lb = zeros(l2,1);

% magically solve this madness:
options=optimset('Display', 'off');
x = linprog(f,A,b,[],[],lb,[],[],options);

%  x = [a_1 ; ... ; a_l ; b_1 ; ... ; b_l] so:
a = x(1:l);
b = x(l+1 : 2*l);

%  w_i = a_i - b_i
w = a - b;
