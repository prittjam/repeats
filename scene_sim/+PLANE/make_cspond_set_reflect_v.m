%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [x,cspond,G,V] = make_cspond_set_reflect_v(N,w,h,varargin)
cfg = struct('theta', 2*pi*rand(1));
cfg = cmp_argparse(cfg,varargin{:});
[x1,~,G1] = PLANE.make_cspond_set_t(N,1,1);
G = [G1 G1];
cspond = transpose(nchoosek(1:2*N,2));
[x2,V] = do_reflection(x1,cfg.theta);
x = reshape([x1;x2],9,[]); 
M = [[w 0; 0 h] [0 0]';0 0 1];
x = reshape(M*reshape(x,3,[]),9,[]);

function [x2,V] = do_reflection(x1,theta)
N = size(x1,2);
n = [cos(theta);sin(theta)];
x0 = 0.9*rand(2,1)-0.45;
T0 = PT.make_T(-x0);
x1o = blkdiag(T0,T0,T0)*x1;
T1 = [ [eye(2)-2*n*n'] zeros(2,1); 0 0 1]; 
x2o =  blkdiag(T1,T1,T1)*x1o;
T2 = PT.make_T(x0);
x2 = blkdiag(T2,T2,T2)*x2o;
V = [n;dot(n,-x0(:,1))];