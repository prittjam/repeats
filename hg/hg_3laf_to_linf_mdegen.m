function is_degen = hg_3laf_to_Hinf_model_degen(u,l)
v = [u;ones(1,size(u,2))];
%detH = l(3)-l(1)-l(2);
%is_degen = any((l'*v)/detH <= 0);
z = l'*v;
is_degen = any(z/z(1) <= 0);