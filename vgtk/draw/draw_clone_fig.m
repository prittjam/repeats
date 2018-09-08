%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function hh2 = draw_clone_fig(hh1)
hh2=figure;
objects=allchild(hh1);
copyobj(get(hh1,'children'),hh2);
