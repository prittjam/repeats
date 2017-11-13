function [model_list,lo_res_list,stats_list] = ...
    fit_coplanar_patterns(solver,x,Gsamp,Gapp,cc,num_planes,varargin)

[ransac,cspond] = make_ransac(solver,x,Gsamp,Gapp,cc,varargin);

for k = 1:num_planes  
    [model0(k),res0(k),model00(k),res00(k),stats_list(k)] = ...
        ransac.fit(x,cspond,Gsamp,Gapp);
    [loss,E] = ransac.eval.calc_loss(x,cspond,model0(k));
    cs = ransac.eval.calc_cs(E);
    res = struct('cs',cs);

    ransac.lo.max_iter = 100;
    [model_list(k),lo_res_list(k)] = ...
        ransac.lo.fit(x,cspond,model0,res0,Gsamp,Gapp);
    
    inl_cspond = cspond(:,logical(res.cs)); 
    inl = unique(inl_cspond);
    if (any(LAF.is_right_handed(x(:,inl))))
        Grect = nan(size(Gapp));  
        Grect(inl) = findgroups(Gapp(inl));
        Hinf = model_list(k).Hinf;
        q = model_list(k).q;
        cc = model_list(k).cc;
        u = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*...
                        LAF.ru_div(x,cc,q));
        A = HG.laf1x2_to_Amu(u,Grect);
        if isempty(A)
            A = eye(3);
            G = Gsamp;
            disp('Metric upgrade failed');
        else
            G = Gapp;
        end
    end
    model_list(k).Hinf = A*model_list(k).Hinf;
end
