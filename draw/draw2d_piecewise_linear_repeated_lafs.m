%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function draw2d_piecewise_linear_repeated_lafs(ax1,x,y,vis,line_style)
vist = vis';
ss = sum(vist>0,2);
vist = vist(find(ss),:);

iv = nonzeros(vist);
[ii,~] = find(vist);
%color_set = repmat(varycolor(size(vis,2)),size(vis,1),1);
color_set = varycolor(max(ii));
color_set = color_set(ii,:);

draw2d_piecewise_linear_lafs(ax1,x(:,iv),y(:,iv),'-',...
                             color_set);