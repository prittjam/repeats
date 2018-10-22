%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,G] = make_cspond_set_lines(N,varargin)
theta = repmat(2*pi*rand(1),1,N);
l = [cos(theta);sin(theta)];
m = [sin(theta);-cos(theta)];
x = 0.9*rand(2,N)-0.45;
l3 = -dot(x,l);
m3 = -dot(x,m);
X = [[l;l3] [m;m3]];
cspond = transpose(nchoosek(1:N,2));
G = repmat(1,1,N);