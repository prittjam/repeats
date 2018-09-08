%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function draw2d_wireframe(ax1,u,edges,varargin)
if nargin < 4
    varargin = 'k';
end

un = renormI(u);
axes(ax1);
hold on;
plot(reshape(un(1,edges),2,[]), ...
     reshape(un(2,edges),2,[]),varargin{:});
hold off;