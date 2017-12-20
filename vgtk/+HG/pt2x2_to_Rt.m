function Rt = pt2x2_to_Rt(u)
u1c = mean(u(1:2,:),2);
u2c = mean(u(3:4,:),2);

a = bsxfun(@minus,u(1:2,:),u1c);
b = bsxfun(@minus,u(3:4,:),u2c);

[U,~,V] = svd(a*b');
R = V*U';
t = u2c-R*u1c;
Rt = [R t; 0 0 1];
