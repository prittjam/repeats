function [s,Hs,T,Ha,Hp] = H_to_HsHaHp(H)
H0 = H;
s = H(9);
H = H/H(9);
Hp = eye(3);
Hp(3,:)  = H(3,:);

H = transpose(H);
Ha = zeros(size(H));

Ha(1) = H(1)-H(3)*H(7);
Ha(4) = H(4)-H(6)*H(7);
Ha(2) = H(2)-H(3)*H(8);
Ha(5) = H(5)-H(6)*H(8);
Ha(3) = H(3);
Ha(6) = H(6);
Ha(9) = 1;

Ha = transpose(Ha);

[Hs2x2,Ha2x2] = qr(Ha(1:2,1:2));

T = eye(3);
T(7:8) = Ha(7:8);
Hs = eye(3);
Hs(1:2,1:2) = Hs2x2; 
T(7:8) = transpose(Hs2x2)*transpose(T(7:8));

Ha = eye(3); 
Ha(1:2,1:2) = Ha2x2/sqrt(det(Ha2x2));

%assert(norm(s*Hs*T*Ha*Hp-H0) < 1e-3, ...
%       'Problem with decomposition');
%

