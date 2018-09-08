%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = render(P,X,coa)
figure;
CAM.render_scene(P,X);

figure;
x = PT.renormI(P*X);
