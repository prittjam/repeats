function m = order_poles(u,v,H)
    u2 = renormI(H*u);
    DD = bsxfun(@plus,sum(u2.^2)',sum(v.^2))-2*u2'*v;
    [~,ind] = min(DD,[],2);
    m = [1:size(u,2);ind'];

