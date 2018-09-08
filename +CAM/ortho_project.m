%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function u = cam_ortho_project(X)
u = [X(1,:);X(2,:);ones(1,size(X,2))];