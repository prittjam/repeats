function un = renorm(u);
d = 1./sqrt(sum(u.^2));
un = bsxfun(@times,u,d);