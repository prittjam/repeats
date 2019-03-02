%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,G,params] = make_group_same_Rt(N,varargin)
cfg = struct('Reflect',0.0);
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

r = ones(1,1);
ind = rand(1,1) < cfg.Reflect;
r(ind) = -1;
theta = 2*pi*rand(1,1);
t = 0.9*rand(2,1)-0.45;
M = Rt.params_to_mtx([theta;t;r]);

x = blkdiag(M,M,M)*LAF.make_random(1,leftover{:});

r = ones(1,1);
ind = rand(1,1) < cfg.Reflect;
r(ind) = -1;
theta = 2*pi*rand(1,1);
t = 0.9*rand(2,1)-0.45;
M = zeros(3,3,N);
M(:,:,1) = eye(3);

A = Rt.params_to_mtx([theta;t;r]);

for k = 2:N
    x(:,k) = blkdiag(A,A,A)*x(:,k-1);
    M(:,:,k) = A*M(:,:,k-1);
end

G = repmat(1,1,size(x,2));
cspond = transpose(nchoosek(1:N,2));

invM1 = multinv(M(:,:,cspond(1,:)));
M2 = M(:,:,cspond(2,:)); 
dM = multiprod(M2,invM1);

T = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(T*reshape(x,3,[]),12,[]);
params = Rt.mtx_to_params(M);

