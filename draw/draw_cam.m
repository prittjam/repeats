function [] = draw_cam(ax1,P,color,label)
if nargin < 3
    color = 'k';
end

if nargin < 4
    label = '\beta';
end

[K R C] = cam_get_KRC_from_P(P);
Beta = R';
draw_affine_csystem(ax1,Beta,C,color,label);