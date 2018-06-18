function u = laf_to_origin(u)
abc = [1 2 4 5 7 8];
u(abc,:) = u(abc,:)-repmat(u([4 5],:),3,1);