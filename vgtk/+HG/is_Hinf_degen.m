function flag = is_Hinf_degen(u,H)
v = renormI(H*u);
flag = any(v(3,:)/v(3,1) <= 0);