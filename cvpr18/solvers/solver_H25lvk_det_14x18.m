function [v1, v2, v3, l1, l2, k] = solver_H25lvk_det_14x18(x1, xp1, x2, xp2, x3, xp3)
data = [x1(1:2);xp1(1:2);x2(1:2);xp2(1:2);x3(1:2);xp3(1:2)];
C = setup_elimination_template(data);
% C0 = C(:,1:14);
% C1 = C(:,15:end);
% C1 = C0 \ C1;
% RR = [-C1(end-2:end,:);eye(4)];
C = gj(C);
RR = [-C(end-2:end,end-3:end);eye(4)];
AM_ind = [7,1,2,3];
AM = RR(AM_ind,:);
[V,D] = eig(AM);
V = V ./ (ones(size(V,1),1)*V(1,:));

sols(1,:) = diag(D).';
sols(2,:) = V(2,:);
sols(3,:) = V(3,:);

k = sols(1,:);
l1 = sols(2,:);
l2 = sols(3,:);

x11 = x1;
x1p1 = xp1;

x21 = x2;
x2p1 = xp2;


x31 = x3;
x3p1 = xp3;



for i = 1:size(l1,2)
        
        M1 =  [                                                           - x11(2)*(k(i)*(x1p1(1)^2 + x1p1(2)^2) + 1) - l1(i)*x11(2)*x1p1(1) - l2(i)*x11(2)*x1p1(2), x11(1)*(k(i)*(x1p1(1)^2 + x1p1(2)^2) + 1) + l1(i)*x11(1)*x1p1(1) + l2(i)*x11(1)*x1p1(2),                                                           0,                                          x11(1)*x1p1(2) - x11(2)*x1p1(1); ...
            - x21(2)*(k(i)*(x2p1(1)^2 + x2p1(2)^2) + 1) - l1(i)*x21(2)*x2p1(1) - l2(i)*x21(2)*x2p1(2), x21(1)*(k(i)*(x2p1(1)^2 + x2p1(2)^2) + 1) + l1(i)*x21(1)*x2p1(1) + l2(i)*x21(1)*x2p1(2),                                                           0,                                          x21(1)*x2p1(2) - x21(2)*x2p1(1) ; ...
            (k(i)*(x11(1)^2 + x11(2)^2) + 1)*(k(i)*(x1p1(1)^2 + x1p1(2)^2) + 1) + l1(i)*x1p1(1)*(k(i)*(x11(1)^2 + x11(2)^2) + 1) + l2(i)*x1p1(2)*(k(i)*(x11(1)^2 + x11(2)^2) + 1),                                                         0, - x11(1)*(k(i)*(x1p1(1)^2 + x1p1(2)^2) + 1) - l1(i)*x11(1)*x1p1(1) - l2(i)*x11(1)*x1p1(2), x1p1(1)*(k(i)*(x11(1)^2 + x11(2)^2) + 1) - x11(1)*(k(i)*(x1p1(1)^2 + x1p1(2)^2) + 1) ; ...
            (k(i)*(x21(1)^2 + x21(2)^2) + 1)*(k(i)*(x2p1(1)^2 + x2p1(2)^2) + 1) + l1(i)*x2p1(1)*(k(i)*(x21(1)^2 + x21(2)^2) + 1) + l2(i)*x2p1(2)*(k(i)*(x21(1)^2 + x21(2)^2) + 1),                                                         0, - x21(1)*(k(i)*(x2p1(1)^2 + x2p1(2)^2) + 1) - l1(i)*x21(1)*x2p1(1) - l2(i)*x21(1)*x2p1(2), x2p1(1)*(k(i)*(x21(1)^2 + x21(2)^2) + 1) - x21(1)*(k(i)*(x2p1(1)^2 + x2p1(2)^2) + 1) ; ...
            l1(i),                                                        l2(i),                                                           1,                                                            0 ];
        
        [~,~,V] = svd(M1);
        
        v1(i) = V(1,end)/V(4,end);
        v2(i) = V(2,end)/V(4,end);
        v3(i) = V(3,end)/V(4,end);
end

% Action =  x
% Quotient ring basis (V) = w^-1,y*w^-1,z*w^-1,x*w^-1,
% Available monomials (RR*V) = x*y*w^-1,x*z*w^-1,x^2*w^-1,w^-1,y*w^-1,z*w^-1,x*w^-1,
function [coeffs,coeffs_ind] = compute_coeffs(data)
coeffs0 = compute_coefficients_H25lvk_det_14x18(data);
coeffs = [coeffs0(266:320);-coeffs0(13:20);1;-coeffs0(21)];
coeffs_ind = [1,12,17,23,28,34,45,57,58,59,62,63,2,13,18,24,29,35,46,58,60,63,3,14,19,25,30,36,47,56,61,65,4,15,20,26,31,37,48,57,61,62,65,5,16,21,27,32,38,49,...
58,61,63,65,6,17,28,39,50,59,62,63,7,18,29,40,51,60,63,8,19,22,30,33,41,52,61,65,9,20,31,42,53,62,65,10,21,32,43,54,63,65,11,22,33,44,55,65,64,64,...
64,64,64,64,64];
function C = setup_elimination_template(data)
[coeffs,coeffs_ind] = compute_coeffs(data);
C_ind = [1,2,3,4,5,6,7,9,10,11,12,13,15,16,17,18,19,20,21,23,25,26,29,30,31,32,33,34,35,36,39,42,43,44,45,46,47,48,49,50,52,53,55,57,58,59,60,61,62,63,...
64,65,67,68,71,72,74,76,77,78,79,80,85,86,88,90,91,92,93,99,100,101,102,103,104,105,106,109,113,114,116,118,119,120,122,127,128,130,132,133,134,135,141,142,144,146,147,148,167,180,...
196,204,220,233,249];
C = zeros(14,18);
C(C_ind) = coeffs(coeffs_ind);

