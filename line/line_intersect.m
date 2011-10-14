function pts = line_intersect(l1,l2)
N = size(l1,2);

xn = l1(3,:).*l2(2,:)-l1(2,:).*l2(3,:);
yn = l1(1,:).*l2(3,:)-l1(3,:).*l2(1,:);

pts = zeros(2,N);

d = 1./(l1(2,:).*l2(1,:)-l1(1,:).*l2(2,:));
ia = abs(d) < 1e6;
d = repmat(d(ia),[2 1]);

pts(:,ia) = [xn(:,ia);yn(:,ia)].*d;
pts(:,~ia) = nan;