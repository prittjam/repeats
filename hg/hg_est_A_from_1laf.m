function Ha = hg_est_A_from_1_laf(v,s,varargin)
m = sum(s);
if m == 1
    Ha = { laf_get_A_from_3p(v(10:18,s))*inv(laf_get_A_from_3p(v(1:9,s))) ...
         };
else
    v2 = v(:,s);
    u = reshape(v2([1:2 10:11 4:5 13:14 7:8 16:17],:),4,[]);    
    s = true(1,size(u,2));
    Ha = hg_est_A_from_3p(u,s);
end