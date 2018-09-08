%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = draw3d_cam_array(ax1,P,varargin)

if nargin < 3
    varargin = {};
end

p = inputParser;
p.KeepUnmatched = true;
p.addParamValue('edges',[]);
p.addParamValue('edge_color','k');
p.parse(varargin{:});

for k = 1:numel(P);
    if ~isempty(P{k})
        draw3d_cam(ax1,P{k},varargin{:}, ...
                   'CamLabel',sprintf('%d',k));
    end
end

e = p.Results.edges;
edge_color = p.Results.edge_color;

hold on;
for k = 1:size(e,2)
    [~,~,c1] = cam_get_KRc_from_P(P{e(1,k)});
    [~,~,c2] = cam_get_KRc_from_P(P{e(2,k)});
    plot3([c1(1);c2(1)],[c1(2);c2(2)],[c1(3);c2(3)], ...
          'Color',edge_color);
end
hold off;
axis equal;