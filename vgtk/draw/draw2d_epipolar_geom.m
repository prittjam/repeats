%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function l = draw2d_epipolar_geom(ax1,ax2,u,F)
%if isempty(varargin)
%    colors = varycolor(size(u,2));
%    varargin = {'LineWidth',2,'Color',colors};
%end

colors = varycolor(size(u,2));
varargin = {'Color',colors};

l = blkdiag(F',F)*u([4:6 1:3],:);

draw2d_lines(ax1,l(1:3,:),'Color',[0 0 0.75],'LineWidth',2);
draw2d_points(ax1,u(1:2,:),varargin{:});

draw2d_lines(ax2,l(4:6,:),'Color',[0 0 0.75],'LineWidth',2);
draw2d_points(ax2,u(4:5,:),varargin{:});