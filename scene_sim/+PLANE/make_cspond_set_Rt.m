%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,G,dtheta,dt] = make_cspond_set_Rt(N)
theta = 2*pi*rand(1,N);
t = 0.9*rand(2,N)-0.45;
r = ones(1,N);
%r = double(rand(1,N) > 0.5);
%r(r==0) = -1;
x = LAF.apply_rigid_xforms(repmat(LAF.make_random(1),1,N), ...
                           [theta;t;r]);

cspond = transpose(nchoosek(1:N,2));
G = repmat(1,1,size(cspond,2));
for k = 1:size(cspond,2)
    dtheta = theta(cspond(2,k))-theta(cspond(1,k));
    dt = t(:,cspond(2,k))-t(:,cspond(1,k));
end

M = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(M*reshape(x,3,[]),12,[]);