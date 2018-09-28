%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,G,V] = make_cspond_same_reflect_v(N,varargin)
cfg = struct('theta', 2*pi*rand(1));
cfg = cmp_argparse(cfg,varargin{:});
x = LAF.make_random(N);
t = 0.9*rand(2,N)-0.45;
x1 = LAF.translate(x,t);
[x2,V] = do_reflection(x1,cfg.theta);
x = reshape([x1;x2],9,[]);
M = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(M*reshape(x,3,[]),12,[]);
%LAF.draw(gca,x);
%LINE.draw(gca,V);
cspond = reshape([1:2*N],2,[]);
G = reshape(repmat([1:N],2,1),1,[]);

function [x2,V] = do_reflection(x1,theta)
N = size(x1,2);
n = [cos(theta);sin(theta)];
x0 = 0.9*repmat(rand(2,1),1,size(x1,2))-0.45;
xo = LAF.translate(x1,-x0);
T = [ [eye(2)-2*n*n'] zeros(2,1); 0 0 1]; 
xp0 =  blkdiag(T,T,T)*xo;
x2 = LAF.translate(xp0,x0);
V = [n;dot(n,-x0(:,1))];