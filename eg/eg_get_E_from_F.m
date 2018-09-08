%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function E = eg_get_E_from_F(F,K)
E1 = K'*F*K;
[U D V] = svd( E1 ); 
D(2,2) = D(1,1);
E = U*D*V';