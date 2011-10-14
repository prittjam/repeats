function [Fa] = faff_four_points_exact(x)
x1 = [x(1:3,:)]';
x2 = [x(4:6,:)]';
Ah = [zeros(3,3)                          -repmat(x2(1:3,3),[1 3]).*x1(1:3,:)    x2(1:3,2).*x1(1:3,3); 
      repmat(x2(1:3,3),[1 3]).*x1(1:3,:)   zeros(3,3)                           -x2(1:3,1).*x1(1:3,3)];
[U S V] = svd(Ah);
Ha = [V(1:3,end)';V(4:6,end)';[0 0 V(7,end)]];

dHa = det(Ha);
N = 20;
Fa = {[]};
if (dHa < N || dHa > 1/N)
l = cross(Ha*x1(end,:)',x2(end,:)');
e2 = [-l(2);l(1);0];
Fa = {skew(e2)*Ha};
end