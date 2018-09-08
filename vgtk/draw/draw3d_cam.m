%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = draw3d_cam(ax1,P,varargin)
if nargin < 3
    varargin = {};
end

p = inputParser;
p.KeepUnmatched = true;
p.addParamValue('color','k',@ischar);
p.addParamValue('camlabel',[]);
p.parse(varargin{:});

camlabel = p.Results.camlabel;

[K R c] = cam_get_KRc_from_P(P);
Beta = R';

draw3d_affine_csystem(ax1,Beta,c,varargin{:});

hold on;
plot3(c(1),c(2),c(3),'bo');

if ~isempty(camlabel)
    text(c(1)-0.1,c(2)-0.1,c(3), ...
         camlabel, ...
         'color', p.Results.color);
end

hold off;