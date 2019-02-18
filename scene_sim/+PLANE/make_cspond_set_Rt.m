%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,G,params] = make_cspond_set_Rt(N,varargin)
cfg = struct('reflect',false);
cfg = cmp_argparse(cfg,varargin{:});

if cfg.reflect
    r = -ones(1,N);
else
    r = ones(1,N);
end

theta = 2*pi*rand(1,N);
t = 0.9*rand(2,N)-0.45;
M = Rt.params_to_mtx([theta;t;r]);

x = PT.mtimesx(M,repmat(LAF.make_random(1),1,N));
G = repmat(1,1,size(x,2));
cspond = transpose(nchoosek(1:N,2));

invM1 = multinv(M(:,:,cspond(1,:)));
M2 = M(:,:,cspond(2,:)); 
dM = multiprod(M2,invM1);

M = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(M*reshape(x,3,[]),12,[]);
params = Rt.mtx_to_params(dM);