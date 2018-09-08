%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function hp = draw2d_points(ax1,u,varargin)
if (size(u,1) > 2)
    u = renormI(u);
end

%axes(ax1);

v = axis;
xmin = min([u(1,:) v(1)]);
xmax = max([u(1,:) v(2)]);
ymin = min([u(2,:) v(3)]);
ymax = max([u(2,:) v(4)]);

%axis([xmin-5 xmax+5 ymin-5 ymax+5]);

hold on;
scatter(u(1,:),u(2,:),16,varargin{2},'filled');
hold off;

%set(get(hp,'Children'), ... 
%    'LineWidth', 1,'Marker', 'o', ...
%    'MarkerSize', 7, 'MarkerEdgeColor', [.2 .2 .2], ...
%    'MarkerFaceColor' , [.75 .75 1]);