%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,G,params] = make_Rt_group(N,varargin)
cfg = struct('reflect',0.0);
cfg = cmp_argparse(cfg,varargin{:});
X = [];
cspond = [];
G = [];
for k = 1:numel(N)
    r = ones(1,N(k));
    ind = rand(1,N(k)) < cfg.reflect;
    r(ind) = -1;
    theta = 2*pi*rand(1,N(k));
    t = 0.9*rand(2,N(k))-0.45;
    M = Rt.params_to_mtx([theta;t;r]);

    x = PT.mtimesx(M,repmat(LAF.make_random(1),1,N(k)));
    Gn = repmat(1,1,size(x,2));
    cspondn = transpose(nchoosek(1:N(k),2));

    invM1 = multinv(M(:,:,cspondn(1,:)));
    M2 = M(:,:,cspondn(2,:)); 
    dM = multiprod(M2,invM1);

    T = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
    Xn = reshape(T*reshape(x,3,[]),12,[]);
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