%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [C2, C2_dual, M] = arandjelovic_canonicalize_ellipses(CC1)
M = calc_arandjelovic_faff_canonicalize(CC1(:,:,1), CC1(:,:,2));
C2 = M'*CC1(:,:,2)*M;
T = make_T(calc_ellipse_center(C2));
C2_dual = inv(T'*C2*T);
end

function M = calc_arandjelovic_faff_canonicalize(C1,C2)
A = canonicalize_ellipse(C1);
C2n_cc = calc_ellipse_center(A'*C2*A);
theta = atan2(C2n_cc(2),C2n_cc(1));
if (sign(theta) < 0)
    phi = -pi/2-theta;
else
    phi = pi/2-theta;
end
R = [cos(phi)  sin(phi)  0; 
     -sin(phi)  cos(phi) 0; 
          0          0  1];
M = A*R;

%theta
%phi
%debug_plot_ellipses(A'*C1*A, A'*C2*A);
end

function M = canonicalize_ellipse(C)
    cc = calc_ellipse_center(C);
    [Q,D] = eig(C(1:2,1:2));
    W = Q*diag(1./sqrt(diag(D)));
    M = [W cc;0 0 1];
end


function [] = debug_plot_ellipses(CC1, CC2)
figure;
hold on;
draw_ellipse(CC1,'r');
draw_ellipse(CC2,'g');
axis equal;
hold off;
end
