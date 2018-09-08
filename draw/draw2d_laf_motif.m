%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function draw2d_laf_motif(ax0,u,vis,varargin)
if isempty(varargin)
    varargin = {'LineWidth',3};
end

colors = varycolor(size(vis,2));
for j = 1:size(vis,2)
    draw2d_lafs(ax0,u(:,nonzeros(vis(:,j))), ...
                'Color',colors(j,:), ...
                varargin{:});
end