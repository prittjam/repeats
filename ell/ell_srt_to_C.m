%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function M = ell_srt_to_C(sx,sy,alpha,tx,ty)
c = cos(alpha);
s = sin(alpha);
c2 = c.*c;
s2 = s.*s;
sx2  = 1./sx.^2;
sy2 = 1./sy.^2;

m11 = permute(c2.*sx2+s2.*sy2,[1 3 2]);
m12 = permute(c.*s.*sx2-c.*s.*sy2,[1 3 2]);
m22 = permute(c2.*sy2+s2.*sx2,[1 3 2]);
m13 = permute(-m11.*tx-m12.*ty,[1 3 2]);
m23 = permute(-m12.*tx-m22.*ty,[1 3 2]);
m33 = ones(1,1,numel(m23));

M = [m11 m12 m13; ...
     m12 m22 m23; ...
     m13 m23 m33];
