function [] = draw3d_cam(ax1,P,color,label)
if nargin < 3
    color = 'k';
end

if nargin < 4
    label = '\beta';
end

[K R C] = cam_get_KRC_from_P(P);
Beta = R';

draw3d_affine_csystem(ax1,50*Beta,C,color,label);

hold on;
plot3(C(1),C(2),C(3),'bo');
hold off;