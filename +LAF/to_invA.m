function invA = to_invA(v)
u = LAF.renormI(v);

u1 = u(1,:);
u2 = u(2,:);
u3 = u(3,:);
u4 = u(4,:);
u5 = u(5,:);
u6 = u(6,:);
u7 = u(7,:);
u8 = u(8,:);
u9 = u(9,:);

a = 1./(u1.*u5.*u9-u1.*u6.*u8-u2.*u4.*u9+u2.*u6.*u7+u3.*u4.*u8-u3.*u5.*u7);

b  = [ u2.*u6-u3.*u5; ...
       u5.*u9-u6.*u8; ...
      -u3.*u5+u9.*u5+u2.*u6+u3.*u8-u6.*u8-u2.*u9; ...
       u3.*u4-u1.*u6; ...
       u6.*u7-u4.*u9; ...
       u3.*u4-u9.*u4-u1.*u6-u3.*u7+u6.*u7+u1.*u9; ...
       u1.*u5-u2.*u4; ...
       u4.*u8-u5.*u7; ...
       -u2.*u4+u8.*u4+u1.*u5+u2.*u7-u5.*u7-u1.*u8 ];
       
invA = squeeze(reshape(bsxfun(@times,a,b),3,3,[]));

if ndims(invA) > 2
    invA = squeeze(mat2cell(invA,3,3,ones(1,size(invA,3))));
end