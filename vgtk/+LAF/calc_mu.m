function mut = calc_mu(dr)
tmp = [dr(:).u];
m = [(tmp(1:2,:)+tmp(4:5,:)+tmp(7:8,:))/3];
mut = mat2cell(m,2,ones(1,numel(dr)));