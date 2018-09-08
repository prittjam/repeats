%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function F = eg_make_F_from_2P(P1,P2)
%[K R C] = cam_factor_P(P1);
%e2 = P2*C;
%F = mtx_make_skew_3x3(e2)*P2*pinv(P1);
%
X1 = P1([2 3],:);
X2 = P1([3 1],:);
X3 = P1([1 2],:);
Y1 = P2([2 3],:);
Y2 = P2([3 1],:);
Y3 = P2([1 2],:);
 
F = [det([X1; Y1]) det([X2; Y1]) det([X3; Y1])
     det([X1; Y2]) det([X2; Y2]) det([X3; Y2])
     det([X1; Y3]) det([X2; Y3]) det([X3; Y3])];