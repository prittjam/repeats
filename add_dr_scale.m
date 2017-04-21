function fdr = add_dr_scale(fdr)
area = LAF.calc_scale([fdr(:).u]);
m = abs(1./nthroot(area,3));
sct = mat2cell(m,1,ones(1,numel(fdr)));
[fdr(:).sc] = sct{:};

%tmp = [fdr(:).u];
%m = [(tmp(1:2,:)+tmp(4:5,:)+tmp(7:8,:))/3];
%mut = mat2cell(m,2,ones(1,numel(fdr)));
