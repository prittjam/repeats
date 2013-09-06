function model_list = eg_est_Fa_from_2e(v)
model_list = {};

u = zeros(12,2);

u(1:6,:) = ell_from_laf(v(1:9,:));
u(7:12,:) = ell_from_laf(v(10:18,:));

CC1 = squeeze(mat2cell(zeros(3,3,2),3,3,ones(1,2)));
CC2 = squeeze(mat2cell(zeros(3,3,2),3,3,ones(1,2)));

ia = find(triu(ones(3)) == 1);

CC1{1}(ia) = u(1:6,1);
CC1{1} = CC1{1}+tril(CC1{1}.',-1);
CC1{2}(ia) = u(1:6,2);
CC1{2} = CC1{2}+tril(CC1{2}.',-1);

CC2{1}(ia) = u(7:12,1);
CC2{1} = CC2{1}+tril(CC2{1}.',-1);
CC2{2}(ia) = u(7:12,2);
CC2{2} = CC2{2}+tril(CC2{2}.',-1);

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

if any(isnan(C))
    return;
end

if any(isinf(C))
    return;
end

t = roots(C);

ia = find(~imag(t));

Fa_list = [];

if (~isempty(ia))
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
        model_list{i} = invM2'*Ft(:,:,i)*invM1;
    end
else
    jjj = 3;
end

function [C2, C2_dual, M] = ell_canonicalize(CC1)
M = calc_arandjelovic_faff_canonicalize(CC1{1}, CC1{2});
C2 = M'*CC1{2}*M;
T = mtx_make_T(ell_calc_center(C2));
C2_dual = inv(T'*C2*T);

function M = calc_arandjelovic_faff_canonicalize(C1,C2)
A = ell_normalize(C1);
C2n_cc = ell_calc_center(A'*C2*A);
theta = atan2(C2n_cc(2),C2n_cc(1));
if (sign(theta) < 0)
    phi = -pi/2-theta;
else
    phi = pi/2-theta;
end
R = mtx_make_Rz(phi);
M = A*R;
