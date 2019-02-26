%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,G,params] = make_group_Rt(N,varargin)
cfg = struct('reflect',0.0);
cfg = cmp_argparse(cfg,varargin{:});

r = ones(1,N);
ind = rand(1,N) < cfg.reflect;
r(ind) = -1;
theta = 2*pi*rand(1,N);
t = 0.9*rand(2,N)-0.45;
M = Rt.params_to_mtx([theta;t;r]);

x = PT.mtimesx(M,repmat(LAF.make_random(1),1,N));
G = repmat(1,1,size(x,2));
cspond = transpose(nchoosek(1:N,2));

invM1 = multinv(M(:,:,cspond(1,:)));
M2 = M(:,:,cspond(2,:)); 
dM = multiprod(M2,invM1);

T = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(T*reshape(x,3,[]),12,[]);
params = Rt.mtx_to_params(dM);