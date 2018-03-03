function u = laf_reflectx(u);
abc = [1 4 7];
u(abc,:) = bsxfun(@times,[-1 -1 -1]',u(abc,:));