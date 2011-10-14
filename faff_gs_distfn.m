function d = faff_gs_distfn(F, x, t)
x1 = [x(1:2,:)];
x2 = [x(4:5,:)];

X = [x2(1:2,:);x1(1:2,:);ones(1,size(x1,2))];
f = [F(1:2,3)' F(3,1:2) F(3,3)]';
ff = repmat(f,[1 size(x1,2)]);
d = 1./sum(f(1:4).^2).*sum(X.*ff,1).^2;