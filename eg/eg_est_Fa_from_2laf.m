function F = eg_est_Fa_from_2laf(u)
    v = [reshape(u(1:9,:),3,[]); ...
         reshape(u(10:18,:),3,[])];
    F = eg_est_Fa_from_4p(v);