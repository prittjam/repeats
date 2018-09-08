%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function draw_3d_ellipse(C,M)
t = linspace(0,2*pi,100);
[Q D] = eig(C(1:2,1:2));
W = [Q*diag(1./sqrt(diag(D))) zeros(2,1);zeros(1,2) 1];
X = renormI(M*W*[cos(t);sin(t);ones(1,length(t))]);
plot3(X(1,:),X(2,:),X(3,:));
end