%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,G,params] = make_same_Rt_group(N,varargin)
cfg = struct('Reflect',0.0);
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

X = [];
cspond = [];
G = [];

for k = 1:N(k)
    r = ones(1,1);
    ind = rand(1,1) < cfg.Reflect;
    r(ind) = -1;
    theta = 2*pi*rand(1,1);
    t = 0.9*rand(2,1)-0.45;
    M = Rt.params_to_mtx([theta;t;r]);
    x = blkdiag(M,M,M)*LAF.make_random(1,leftover{:});
end
    
r = ones(1,1);
ind = rand(1,1) < cfg.Reflect;
r(ind) = -1;

theta = 2*pi*rand(1,1);
t = 0.9*rand(2,1)-0.45;
M = zeros(3,3,N);
M(:,:,1) = eye(3);

A = Rt.params_to_mtx([theta;t;r]);

for k1 = 1:numel(N)
    for k2 = 2:N(k1)
        k = sum(N(1:k-1));       
        x(:,k) = blkdiag(A,A,A)*x(:,k1-1);
        M(:,:,k1) = A*M(:,:,k1-1);
    end
end

    Gn = repmat(1,1,size(x,2));
    cspondn = transpose(nchoosek(1:N,2));
    T = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
    Xn = reshape(T*reshape(x,3,[]),12,[]);
    
    invM1 = multinv(M(:,:,cspondn(1,:)));
    M2 = M(:,:,cspondn(2,:)); 
    dM = multiprod(M2,invM1);
    paramsn = Rt.mtx_to_params(dM);    

    params{k} = paramsn;
    X = [X Xn];

    if ~isempty(cspond)
        cspondn = cspondn+max(cspond(:));
        Gn = Gn+max(G);
    end
    cspond = [cspond cspondn];
    G = [G Gn];
end

keyboard;


