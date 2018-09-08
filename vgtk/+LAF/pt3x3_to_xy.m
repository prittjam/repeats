%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [x,y] = p3x3_to_xy(u)
x = reshape(u([1 4 7],:),1,[]);
y = reshape(u([2 5 8],:),1,[]);