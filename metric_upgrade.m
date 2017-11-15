function [] = metric_upgrade()
uG = unique(Gapp);

for k1 = 1:numel(uG)
    ind 





if (any(LAF.is_right_handed(x(:,~isnan(G)))))
    Hinf = model_list(k).Hinf;
    q = model_list(k).q;
    cc = model_list(k).cc;
    xr = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*...
                     LAF.ru_div(x,cc,q));
    %        A = HG.laf1x2_to_Amu(u,Grect);
    A = HG.laf1x2_to_Amur(xr,G);
    if isempty(A)
        A = eye(3);
        G = Gsamp;
        disp('Metric upgrade failed');
    else
            G = Gapp;
    end
end 
