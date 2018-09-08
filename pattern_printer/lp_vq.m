%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function w = lp_vq(K)
[m,n]= size(K);

gamma = reshape(1./sum(K),[],1);
f = [gamma ; gamma];
A = [-K  K];
b = (-1)*ones(m,1);
lb = zeros(2*n,1);

options = optimoptions('linprog', ...
                       'Display', 'off', ...
                       'Algorithm','dual-simplex');

x = linprog(f,A,b,[],[],lb,[],[],options);
%x = linprog(f,A,b,[],[],lb,[],[]);
w = x(1:n)-x(n+1:2*n);
