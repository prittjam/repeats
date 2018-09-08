%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = pt_draw(h,u)

cdata = get(h,'CData');
dx = size(cdata,2);
dy = size(cdata,1);

set(h,'XData',[0 dx-1]);
set(h,'YData',[0 dy-1]);

axes(get(h,'Parent'));

hold on;
hp = scatter(u(1,:),u(2,:));
hold off;

set(get(hp,'Children'), ... 
    'LineWidth', 1,'Marker', 'o', ...
    'MarkerSize', 7, 'MarkerEdgeColor', [.2 .2 .2], ...
    'MarkerFaceColor' , [.75 .75 1]);