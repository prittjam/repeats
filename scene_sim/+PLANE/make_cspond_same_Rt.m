%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,G,params] = make_cspond_same_Rt(N,varargin)
cfg = struct('reflect',0.0);
cfg = cmp_argparse(cfg,varargin{:});

r = ones(1,N);
theta = 2*pi*rand(1,N);
t = 0.9*rand(2,N)-0.45;
M = Rt.params_to_mtx([theta;t;r]);
x = PT.mtimesx(M,LAF.make_random(N));


r = ones(1,1);
ind = rand(1,1) < cfg.reflect;
r(ind) = -1;
theta = 2*pi*rand(1,1);
t = 0.9*rand(2,1)-0.45;
M = repmat(Rt.params_to_mtx([theta;t;r]),1,1,N);
params = Rt.mtx_to_params(M);

xp = PT.mtimesx(M,x);
y = reshape([x;xp],9,[]);

T = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(T*reshape(y,3,[]),12,[]);

cspond = reshape([1:2*N],2,[]);
G = reshape(repmat([1:N],2,1),1,[]);
