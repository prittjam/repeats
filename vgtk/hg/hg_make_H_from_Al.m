function H = hg_make_H_from_Al(A,l)
Hinf = eye(3);
Hinf(3,:) = l';
H = A*Hinf;