%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [K,Q,D,W,l,qf] = draw(ax1,CC,varargin)
M = 100;

if ~iscell(CC)
    CC = {CC};
end

x = zeros(3,M*numel(CC));

for k = 1:numel(CC)
    C = CC{k};
    [A,m] = ELL.get_A_from_C(C);
    t = linspace(0,2*pi,M);
    x(:,M*(k-1)+1:M*k) = PT.renormI(A*[cos(t);sin(t);ones(1,length(t))]);
end

mpdc = distinguishable_colors(numel(CC));
hold(ax1,'on');
set(ax1,'ColorOrder',mpdc);    % <--- HERE
plot(reshape(x(1,:),M,[]),reshape(x(2,:),M,[]),varargin{:});
hold(ax1,'off');
