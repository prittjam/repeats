function [model_list,lo_res_list,stats_list] = ...
    fit_coplanar_patterns(solver,x,Gsamp,Gapp,cc,num_planes,varargin)

[ransac,corresp] = make_ransac(solver,x,Gsamp,Gapp,cc,varargin);

for k = 1:num_planes  
    [model0(k),res0(k),model00(k),res00(k),stats_list(k)] = ...
        ransac.fit(x,corresp,Gsamp,Gapp);
%    [loss,E] = ransac.eval.calc_loss(x,corresp,model0);
%    cs = ransac.eval.calc_cs(E);
%    res = struct('cs',cs);
    cs = res0(k).cs;
    
    ransac.lo.max_iter = 10;
    [model_list(k),lo_res_list(k)] = ...
        ransac.lo.fit(x,corresp,model0,res0,Gsamp,Gapp);
    
    Grect = nan(size(Gapp));  
    inl = unique(corresp(:,lo_res_list(k).cs));
    Grect(inl) = findgroups(Gapp(inl));
    if (any(LAF.is_right_handed(x(:,inl))))
        Hinf = model_list(k).Hinf;
        u = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*...
                        LAF.ru_div(x,model_list(1).cc, ...
                                   model_list(1).q));
        Ha = HG.laf1x2_to_Amu(u,Grect);
        if ~isempty(Ha)
            model_list(k).Hinf = Ha*model_list(k).Hinf;
        else
            disp('Metric upgrade failed');
        end
    else
        disp('No reflections detected for metric upgrade');
    end

end
