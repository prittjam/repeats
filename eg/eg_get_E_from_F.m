function E = eg_get_E_from_F(F,K)
E1 = K'*F*K;
[U D V] = svd( E1 ); 
D(2,2) = D(1,1);
E = U*D*V';