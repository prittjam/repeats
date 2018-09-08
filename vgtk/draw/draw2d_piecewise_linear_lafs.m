%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function draw2d_piecewise_linear_lafs(ax1,x,y,line_style,cmap)
k = floor(size(x,1)/2);

tmp = [];
if nargin > 4
    tmp = get(ax1,'ColorOrder');
    set(ax1,'ColorOrder', cmap);
end

hold all;
h1 = plot(x,y,line_style, ...
          'LineWidth'       , 2);

plot(x(k:k:end)', ...
     y(k:k:end)', 'd', ...
     'MarkerEdgeColor','k', ...
     'MarkerFaceColor',[.49 1 .63], ...
     'MarkerSize',4)

plot(x(1:2*k:end), ...
     y(1:2*k:end), 'o', ...
     'MarkerEdgeColor','k', ...
     'MarkerFaceColor',[0.43 0.81 0.96], ...
     'MarkerSize',4)
hold off;

if nargin > 4
    set(ax1,'ColorOrder', tmp);
end