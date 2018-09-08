%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function draw2d_piecewise_linear(ax1,x,y,varargin)
if nargin < 4
    varargin = 'k';
end

axes(ax1);
hold on;
plot(x,y,varargin{:});
hold off;