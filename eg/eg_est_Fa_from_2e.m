%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function model_list = eg_est_Fa_from_2e(v)
model_list = [];

u = zeros(12,2);

u(1:6,:) = ell_from_laf(v(1:9,:));
u(7:12,:) = ell_from_laf(v(10:18,:));

CC1 = squeeze(mat2cell(zeros(3,3,2),3,3,ones(1,2)));
CC2 = squeeze(mat2cell(zeros(3,3,2),3,3,ones(1,2)));

ia = find(triu(ones(3)) == 1);

CC1{1}(ia) = u(1:6,1);
CC1{1} = CC1{1}+tril(CC1{1}',-1);
CC1{2}(ia) = u(1:6,2);
CC1{2} = CC1{2}+tril(CC1{2}',-1);

CC2{1}(ia) = u(7:12,1);
CC2{1} = CC2{1}+tril(CC2{1}',-1);
CC2{2}(ia) = u(7:12,2);
CC2{2} = CC2{2}+tril(CC2{2}',-1);

%figure;
%ax1 = subplot(1,2,1);
%draw2d_lafs(ax1,v(1:9,:));
%draw_ellipse(ax1,CC1{1});
%draw_ellipse(ax1,CC1{2});
%
%ax2 = subplot(1,2,2);
%draw2d_lafs(ax2,v(10:18,:));
%draw_ellipse(ax2,CC2{1});
%draw_ellipse(ax2,CC2{2});
%
[C21 C21_dual M1] = ell_canonicalize(CC1);
[C22 C22_dual M2] = ell_canonicalize(CC2);

cc1 = ell_calc_center(C21);
cc2 = ell_calc_center(C22);
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

if ~any(isinf(C) | isnan(C) | imag(C))
    t = roots(C);

    ia = find(~imag(t));

    Fa_list = [];

    if (~isempty(ia))
        cosa = 1./sqrt(1+t(ia).^2);
        sina = sign(t(ia)).*sqrt(1-cosa.^2);

        cosb = s*cosa;

        sg_sinb = sign(((p-p2)*(1+t(ia).^2)-2*q*t(ia)+(r-p-(r2-p2)*s^2))./(2*s^2*q2));
        sinb = sg_sinb.*sqrt(1-cosb.^2);
        
        Ft = zeros(3,3,length(cosa));
        
        Ft(3,2,:) = [cosa];
        Ft(2,3,:) = [-cosb];
        Ft(3,1,:) = [-sina];
        Ft(1,3,:) = [sinb];
        invM1 = inv(M1);
        invM2 = inv(M2);
        
        for i=1:size(Ft,3)
            if ~any(imag(Ft(:,:,i)))
                model_list{i} = invM2'*Ft(:,:,i)*invM1;
            end
        end
    end
end

function [C2, C2_dual, M] = ell_canonicalize(CC1)
M = calc_arandjelovic_faff_canonicalize(CC1{1}, CC1{2});
C1 = M'*CC1{1}*M;
C2 = M'*CC1{2}*M;

%figure;
%hold on;
%draw_ellipse(gca,C1);
%draw_ellipse(gca,C2);
%hold off;
%kkk = 3;

m2 = ell_calc_center(C2);
T = mtx_make_T(m2(1:2));
C2_dual = inv(T'*C2*T);

function M = calc_arandjelovic_faff_canonicalize(C1,C2)
A = ell_get_TRS_from_C(C1);

%C1a = A'*C1*A;
C2a = A'*C2*A;

%figure;
%hold on;
%draw_ellipse(gca,C1a);
%draw_ellipse(gca,C2a);
%hold off;

m2 = ell_calc_center(C2a);
theta = atan2(m2(1),m2(2));
R = mtx_make_Rz(theta);
M = A*R;