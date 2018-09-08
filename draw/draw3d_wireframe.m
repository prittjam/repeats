%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = draw3d_wireframe(ax1,X,edges)
axes(ax1);

hold on;
plot3(reshape(X(1,edges),2,[]), ...
      reshape(X(2,edges),2,[]), ...
      reshape(X(3,edges),2,[]),'k');
hold off;
