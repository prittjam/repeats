%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function draw2d_repeated_reflected_lafs(ax0,u,vis,varargin)
reflect = rpt_geom_find_oriented_vis(u,vis);

if nargin < 4
    line_style = '-o';
end

colors = varycolor(2);

for i = find(reflect == 1)
    draw2d_lafs(gca,u(:,nonzeros(vis(i,:))),'Color',colors(1,:));
end

for i = find(reflect == -1)
    draw2d_lafs(gca,u(:,nonzeros(vis(i,:))),'Color',colors(2,:));
end