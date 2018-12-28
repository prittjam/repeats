%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,G,dtheta,dt] = make_cspond_same_Rt(N)
x = LAF.make_random(N);
t = 0.9*rand(2,N)-0.45;
T = Rt.params_to_mtx([zeros(1,size(t,2));t;ones(1,size(t,2))]);
x1 = PT.mtimesx(T,x);
[x2,dtheta,dt] = do_rigid_xform(x1);
x = reshape([x1;x2],9,[]);
M = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(M*reshape(x,3,[]),12,[]);
cspond = reshape([1:2*N],2,[]);
G = reshape(repmat([1:N],2,1),1,[]);
          
function [x2,dtheta,dt] = do_rigid_xform(x1)
N = size(x1,2);
theta = repmat(2*pi*rand(1),1,size(x1,2));
%theta = repmat(pi/4,1,size(x1,2));
n = [cos(theta);sin(theta)];
a = [(-0.5-x1(4,:))./n(1,:);
     (0.5-x1(4,:))./n(1,:); ...
     (-0.5-x1(5,:))./n(2,:);
     (0.5-x1(5,:))./n(2,:)];
[as,ind] = sort(a,1);
l = max(as(2,:));
u = min(as(3,:));
x2 = zeros(size(x1));
t = (u-l)*(0.9*rand(1)+0.1);
dt = bsxfun(@times,t,n);
uu = [theta; ...
      dt; ...
      ones(1,N)];
T = Rt.params_to_mtx(uu);
x2 = PT.mtimesx(T,x1);
dtheta = theta;