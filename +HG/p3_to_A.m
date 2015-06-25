function A = p3_to_A(u)
t1 = mean(u(1:2,:),2);
t2 = mean(u(3:4,:),2);
M = bsxfun(@minus,u([1 2 3 4],:),[t1;t2])';

[~,~,vv] = svd(M);
V = vv(:,1:2);
B = V(1:2,1:2);
C = V(3:4,1:2);
H = C*inv(B);

A = [H t2-H*t1; zeros(1,2) 1];