function [model_list,lo_res_list,stats_list,cspond] = ...
    fit_coplanar_patterns(solver,x,Gsamp,Gapp,cc,num_planes,varargin)
[ransac,cspond] = make_ransac(solver,x,Gsamp,Gapp,cc,varargin);
[model0,res0,stats_list] = ...
        ransac.fit(x,cspond,Gsamp,Gapp);
ransac.lo.max_iter = 150;
[model_list,lo_res_list] = ...
    ransac.lo.fit(x,cspond,model0,res0,Gsamp,Gapp);

Grect = nan(size(Gapp));
inl = unique(cspond(:,res0.cs));
Grect(inl) = findgroups(Gapp(inl));

Hinf = model_list.Hinf;
cc = model_list.cc;
q = model_list.q;
xr = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*LAF.ru_div(x,cc,q));
A = HG.laf1x2_to_Amu(xr,Grect);
if ~isempty(A)
    model_list.Hinf = A*model_list.Hinf;  
else
    A = HG.laf1x2_to_Amur(xr,Grect);
    if ~isempty(A)
        model_list.Hinf = A*model_list.Hinf;  
        %else
%    disp(['Metric upgrade failed']);
    end
end
    %end
