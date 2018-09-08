%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [Faa] = faff_four_points(x1,x2)
    A = [x2(1:2,:)' x1(1:2,:)' ones(size(x2,2),1)];
    f = null(A);
    Fa(1:2,3) = f(1:2);
    Fa(3,1:2) = f(3:4);
    Fa(3,3) = f(5);
    Faa = {Fa};