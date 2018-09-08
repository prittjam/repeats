%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [H,H2,err1,err2] = hg_2elin2(C1a, C2a, C1b, C2b)
% function H = hg_2elin(C1a, C2a, C1b, C2b)
% correspondences: C1a <-> C1b, C2a <-> C2b.
%
% INPUT
%  Four real symmetric nonsingular 3x3 matrices:
%    C1a, C2a - the conic coefficient matrices in the first view
%    C1b, C2b - the corresponding conics in the second view
%
% For more details see  Chum, Matas ICPR 2012:.
% Homography Estimation from Correspondences of Local Elliptical Features
%
% (C) Ondra Chum 2012


N1 = inv(C2A(C1a));
D1 = C2A(C1b);
N2 = inv(C2A(C2a));
D2 = C2A(C2b);

H = HG.icpr12.A2toRH (N1, D1, N2, D2);

u = ELL.get_common_real_poles(C1a,C2a);
v = ELL.get_common_real_poles(C1b,C2b);

H2 = H;
if (size(u,2) > 0) & (size(v,2) > 0)
    u2 = renormI(H*u);
    DD = bsxfun(@plus,sum(u2.^2)',sum(v.^2))-2*u2'*v;
    [dd,ind] = min(DD,[],2);

    ia = find(dd < 20);
    m = [1:size(u,2);ind'];
    uv = [u(:,m(1,ia)); ...
          v(:,m(2,ia))];
    H2 = HG.icpr12.A2toRH2(N1, D1, N2, D2, uv);
    %    H3 = HG.H_from_4pl(uv,l);
end

err1 = HG.sampson_err(uv,H);
err2 = HG.sampson_err(uv,H2);
%err3 = HG.sampson_err(uv,H3);