%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function D = sqdist(X1,X2)
% computes the distance b/w every pair of column vectors in X1, and X2;
% 
%  Author: Michael Bosse (ifni@mit.edu)

if nargin == 1
   X2 = X1;
end

N = size(X1,2);
M = size(X2,2);

X11 = repmat(sum(X1.^2,1)',1,M);
X22 = repmat(sum(X2.^2,1) ,N,1);
X12 = X1'*X2;

D = X11 - 2*X12 + X22; 
