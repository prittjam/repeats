function pts = line_intersect(l1,l2)
n = size(l1,2);
u = [l2(3,:).*l1(2,:)-l1(3,:).*l2(2,:); ...
     -l1(1,:).*l2(3,:)+l1(3,:).*l2(1,:)];
d = l1(1,:).*l2(2,:)-l1(2,:).*l2(1,:);
ia = abs(d) > 1e-8;

pts = zeros(2,n);
pts(:,ia) = bsxfun(@rdivide,u(:,ia),d(:,ia));
pts(:,~ia) = nan;