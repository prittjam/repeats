%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [x,cspond,G,V] = make_cspond_same_reflect_v(N,varargin)
cfg = struct('theta', 2*pi*rand(1));
cfg = cmp_argparse(cfg,varargin{:});

t = 0.9*rand(2,N)-0.45;
A = Rt.params_to_mtx([zeros(1,N);t;ones(1,N)]);
x1 = PT.mtimesx(A,repmat(LAF.make_random(1),1,N));
x2 = do_reflection(x1,cfg.theta);
x = reshape([x1;x2],9,[]);
cspond = reshape([1:2*N],2,[]);
G = reshape(repmat([1:N],2,1),1,[]);
keyboard;


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