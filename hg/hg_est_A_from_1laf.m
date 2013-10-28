function Ha = hg_est_A_from_1laf(v,varargin)
m = size(v,2);
if m == 1
    Ha = { laf_3ptoA(v(10:18,:))*inv(laf_3ptoA(v(1:9,:))) ...
         };
else
    u = reshape(v([1:2 10:11 4:5 13:14 7:8 16:17],:),4,[]);    
    s = true(1,size(u,2));
    Ha = hg_est_A_from_3p(u);
end