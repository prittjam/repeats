function [l,sols] = solver_changeofscale_22_det_norad(x11,x12,x21,x22)
% x11 <-> x12,  x21 <-> x22
% size(x11) = [2,3]


data = [x11(:);x12(:);x21(:);x22(:)];
scale_x = (mean(abs(data)));
data = data/scale_x;

% precompute 3x3 determinants
ind1 = [3,1,1,9,7,7,15,13,13,21,19,19];
ind2 = [6,6,4,12,12,10,18,18,16,24,24,22];
ind3 = [5,5,3,11,11,9,17,17,15,23,23,21];
ind4 = [4,2,2,10,8,8,16,14,14,22,20,20];
xd = data(ind1).*data(ind2)-data(ind3).*data(ind4);
data = [data;xd(1:3:end)-xd(2:3:end)+xd(3:3:end)];

sols = solve(data);
ind_r = max(abs(imag(sols)))<1e-6;
solsr = real(sols(:,ind_r));
l = [solsr(1:2,:);ones(1,size(solsr,2))];
l(1:2,:) = l(1:2,:) / scale_x;



function sols = solve(data)
C = setup_elimination_template(data);
C0 = C(:,1:12);
C1 = C(:,13:end);
C1 = C0 \ C1;
RR = [-C1(end-2:end,:);eye(9)];
AM_ind = [9,7,1,8,2,10,11,12,3];
AM = RR(AM_ind,:);
[V,D] = eig(AM);
V = V ./ (ones(size(V,1),1)*V(1,:));
sols(1,:) = V(2,:);
sols(2,:) = diag(D).';

% Action =  y
% Quotient ring basis (V) = 1,x,x^2,x*y,x*y^2,y,y^2,y^3,y^4,
% Available monomials (RR*V) = x^2*y,x*y^3,y^5,1,x,x^2,x*y,x*y^2,y,y^2,y^3,y^4,
function [coeffs,coeffs_ind] = compute_coeffs(data)
coeffs(1) = -data(7)*data(9)*data(11)*data(25) + data(1)*data(3)*data(5)*data(26);
coeffs(2) = -data(8)*data(9)*data(11)*data(25) - data(7)*data(10)*data(11)*data(25) - data(7)*data(9)*data(12)*data(25) + data(2)*data(3)*data(5)*data(26) + data(1)*data(4)*data(5)*data(26) + data(1)*data(3)*data(6)*data(26);
coeffs(3) = -data(8)*data(10)*data(11)*data(25) - data(8)*data(9)*data(12)*data(25) - data(7)*data(10)*data(12)*data(25) + data(2)*data(4)*data(5)*data(26) + data(2)*data(3)*data(6)*data(26) + data(1)*data(4)*data(6)*data(26);
coeffs(4) = -data(8)*data(10)*data(12)*data(25) + data(2)*data(4)*data(6)*data(26);
coeffs(5) = -data(7)*data(9)*data(25) - data(7)*data(11)*data(25) - data(9)*data(11)*data(25) + data(1)*data(3)*data(26) + data(1)*data(5)*data(26) + data(3)*data(5)*data(26);
coeffs(6) = -data(8)*data(9)*data(25) - data(7)*data(10)*data(25) - data(8)*data(11)*data(25) - data(10)*data(11)*data(25) - data(7)*data(12)*data(25) - data(9)*data(12)*data(25) + data(2)*data(3)*data(26) + data(1)*data(4)*data(26) + data(2)*data(5)*data(26) + data(4)*data(5)*data(26) + data(1)*data(6)*data(26) + data(3)*data(6)*data(26);
coeffs(7) = -data(8)*data(10)*data(25) - data(8)*data(12)*data(25) - data(10)*data(12)*data(25) + data(2)*data(4)*data(26) + data(2)*data(6)*data(26) + data(4)*data(6)*data(26);
coeffs(8) = -data(7)*data(25) - data(9)*data(25) - data(11)*data(25) + data(1)*data(26) + data(3)*data(26) + data(5)*data(26);
coeffs(9) = -data(8)*data(25) - data(10)*data(25) - data(12)*data(25) + data(2)*data(26) + data(4)*data(26) + data(6)*data(26);
coeffs(10) = -data(25) + data(26);
coeffs(11) = -data(19)*data(21)*data(23)*data(27) + data(13)*data(15)*data(17)*data(28);
coeffs(12) = -data(20)*data(21)*data(23)*data(27) - data(19)*data(22)*data(23)*data(27) - data(19)*data(21)*data(24)*data(27) + data(14)*data(15)*data(17)*data(28) + data(13)*data(16)*data(17)*data(28) + data(13)*data(15)*data(18)*data(28);
coeffs(13) = -data(20)*data(22)*data(23)*data(27) - data(20)*data(21)*data(24)*data(27) - data(19)*data(22)*data(24)*data(27) + data(14)*data(16)*data(17)*data(28) + data(14)*data(15)*data(18)*data(28) + data(13)*data(16)*data(18)*data(28);
coeffs(14) = -data(20)*data(22)*data(24)*data(27) + data(14)*data(16)*data(18)*data(28);
coeffs(15) = -data(19)*data(21)*data(27) - data(19)*data(23)*data(27) - data(21)*data(23)*data(27) + data(13)*data(15)*data(28) + data(13)*data(17)*data(28) + data(15)*data(17)*data(28);
coeffs(16) = -data(20)*data(21)*data(27) - data(19)*data(22)*data(27) - data(20)*data(23)*data(27) - data(22)*data(23)*data(27) - data(19)*data(24)*data(27) - data(21)*data(24)*data(27) + data(14)*data(15)*data(28) + data(13)*data(16)*data(28) + data(14)*data(17)*data(28) + data(16)*data(17)*data(28) + data(13)*data(18)*data(28) + data(15)*data(18)*data(28);
coeffs(17) = -data(20)*data(22)*data(27) - data(20)*data(24)*data(27) - data(22)*data(24)*data(27) + data(14)*data(16)*data(28) + data(14)*data(18)*data(28) + data(16)*data(18)*data(28);
coeffs(18) = -data(19)*data(27) - data(21)*data(27) - data(23)*data(27) + data(13)*data(28) + data(15)*data(28) + data(17)*data(28);
coeffs(19) = -data(20)*data(27) - data(22)*data(27) - data(24)*data(27) + data(14)*data(28) + data(16)*data(28) + data(18)*data(28);
coeffs(20) = -data(27) + data(28);
coeffs_ind = [1,11,2,1,11,12,3,2,1,11,12,13,4,3,2,12,13,14,4,3,13,14,5,1,11,15,6,5,15,2,11,12,1,16,7,6,5,15,16,3,12,13,2,17,8,5,15,1,11,18,...
9,8,18,6,15,16,2,12,5,19,7,6,16,17,4,13,14,3,4,14,10,20,10,20,8,18,10,8,18,5,15,20,10,20,9,18,19,6,16,8,9,8,18,19,7,16,17,3,13,6,...
20,9,19,10,10,20,19,7,17,9,9,19,17,4,14,7,7,17,14,4];
function C = setup_elimination_template(data)
[coeffs,coeffs_ind] = compute_coeffs(data);
C_ind = [1,12,13,14,17,24,25,26,27,28,29,36,37,38,39,40,41,48,50,51,52,53,61,66,68,72,73,74,77,78,79,80,83,84,85,86,87,88,89,90,91,92,95,96,97,102,104,105,106,108,...
109,110,113,114,115,116,117,118,119,120,122,123,124,125,126,127,128,131,135,136,153,154,162,164,165,166,169,174,176,177,178,180,182,185,186,187,188,189,190,191,194,195,196,197,198,199,200,201,202,203,...
211,213,214,215,219,220,223,225,226,227,231,232,235,237,238,239,243,244,247,251];
C = zeros(12,21);
C(C_ind) = coeffs(coeffs_ind);

