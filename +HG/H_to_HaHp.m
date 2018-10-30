function [Ha,Hp] = H_to_HaHp(H)
H = transpose(H);
Ha = [H(1)-H(3)*H(7) H(2)-H(3)*H(8) H(3); ...
      H(4)-H(6)*H(7) H(5)-H(6)*H(8) H(6); ...
                  0              0     1];
Hp = eye(3);
Hp(3,:) 
