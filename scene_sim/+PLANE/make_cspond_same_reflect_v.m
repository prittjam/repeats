%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,G,v] = make_cspond_same_reflect_v(N,varargin)
cfg = struct('theta', 2*pi*rand(1));
cfg = cmp_argparse(cfg,varargin{:});
x = LAF.make_random(N);
N = size(x,2);
theta = pi*rand(1);
n = [cos(theta);sin(theta)];
T = [ [eye(2)-2*n*n'] zeros(2,1); 0 0 1]; 

t1 = rand(1)*n;
t2 = rand(1)*n;
M2 = Rt.params_to_mtx([0;t1;1]);
M3 = Rt.params_to_mtx([0;t2;1]);
x1 = PT.mtimesx(M2,x);
x2 = PT.mtimesx(M3*T,x);

M4 = Rt.params_to_mtx([0;mean([t1 t2],2);1]);
v = inv(M4)'*[n;0];

%
x = reshape([x1;x2],9,[]);
w = 10;
h = 10;
M2  = [[w 0; 0 h] [0 0]';0 0 1];

%figure;
%LAF.draw(gca,[x1 x2]);
%LINE.draw_extents(gca,v,'LineStyle',':');
%

v = inv(M2')*v;
M = [1 0 0; 0 1 0; 0 0 0; 0 0 1];

X = reshape(M*M2*reshape(x,3,[]),12,[]);
%LAF.draw(gca,x);
%LINE.draw(gca,V);
cspond = reshape([1:2*N],2,[]);
G = reshape(repmat([1:N],2,1),1,[]);
