function vd = get_common_real_poles(C1a, C2a)
Q1 = inv(C1a)*C2a;
[v, e] = eig(Q1);

de = find_real_distinct_eigvals(e);
vd = renormI(v(:,de(find(abs(v(3,de)) > 1000*eps))));

function ind = find_real_distinct_eigvals(ea)
    ind = 1:3;
    e = diag(ea);
    ind(find(imag(e))) = [];
    e2 = e(ind)';
    d2 = bsxfun(@plus,e2'.^2,e2.^2)-2*e2'*e2+diag(ones(1,numel(ind)));
    [ii,jj] = find(d2 < 1000*eps);
    ind2 = union(ii,jj);
    ind(ind2) = [];