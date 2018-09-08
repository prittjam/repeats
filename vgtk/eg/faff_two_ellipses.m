%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [Fa_list] = faff_two_ellipses(x)
x1 = x(:,1);
x2 = x(:,2);

[CC1t] = ellipse_pair_from_laf(x1);
[CC2t] = ellipse_pair_from_laf(x2);
CC1 = cat(3,CC1t(:,:,1),CC2t(:,:,1));
CC2 = cat(3,CC1t(:,:,2),CC2t(:,:,2));

[C21 C21_dual M1] = arandjelovic_canonicalize_ellipses(CC1);
[C22 C22_dual M2] = arandjelovic_canonicalize_ellipses(CC2);
cc1 = calc_ellipse_center(C21);
cc2 = calc_ellipse_center(C22);
s = cc1(2)/cc2(2);

p = C21_dual(1,1);
q = C21_dual(1,2);
r = C21_dual(2,2);

p2 = C22_dual(1,1);
q2 = C22_dual(1,2);
r2 = C22_dual(2,2);

k = r-p2-s^2*(r2-p2);
k0 = k^2 -4*q2^2 * s^2 * (1-s^2);
k1 = -4*q*k;
k2 = 2*(p-p2)*k+4*q^2-4*q2^2*s^2;
k3 = -4*(p-p2)*q;
k4 = (p-p2)^2;

C = [k4 k3 k2 k1 k0];
t = roots(C);

ia = [];
for i = 1:length(t)
    if (isreal(t(i)))
        ia = [ia i];
    end
end
Fa_list = [];
if (length(ia) > 0)
    cosa = 1./sqrt(1+t(ia).^2);
    cosb = s*cosa;
    sina = sign(t(ia)).*sqrt(1-cosa.^2);
    sg_sinb = sign(((p-p2)*(1+t(ia).^2)-2*q*t(ia)+(r-p-(r2-p2)*s^2))./(2*s^2*q2));
    sinb2 = -1*((p-p2)-2*q*sina.*cosa+(r-p-(r2-p2)*s^2).*cosa.^2)./(2*s*q2.*cosa);
    sinb = sqrt(1-cosb.^2);
    
    Ft = zeros(3,3,length(cosa));
    
    Ft(3,2,:) = [cosa];
    Ft(2,3,:) = [-cosb];
    Ft(3,1,:) = [-sina];
    Ft(1,3,:) = [sinb2];
    invM1 = inv(M1);
    invM2 = inv(M2);
    
    for i=1:size(Ft,3)
        Fa_list{i} = invM2'*Ft(:,:,i)*invM1;
    end
else
    jjj = 3;
end

end

function [] = debug_plot_ellipses(CC1, CC2)
figure;
subplot(1,2,1);
hold on;
draw_ellipse(CC1(:,:,1),'r');
draw_ellipse(CC1(:,:,2),'g');
axis([0 1200 0 1200]);
axis equal;
hold off;

subplot(1,2,2);
hold on;
draw_ellipse(CC2(:,:,1),'r');
draw_ellipse(CC2(:,:,2),'g');
axis([0 1200 0 1200]);
axis equal;
hold off;
end
