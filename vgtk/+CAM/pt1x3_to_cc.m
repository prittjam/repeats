function M = pt1x3_to_cc(x,q)
u1 = transpose(x(1,:));
v1 = transpose(x(2,:));
f1 = 1+q*(u1.^2+v1.^2);

u2 = transpose(x(4,:));
v2 = transpose(x(5,:));
f2 = 1+q*(u2.^2+v2.^2);

u3 = transpose(x(7,:));
v3 = transpose(x(8,:));
f3 = 1+q*(u3.^2+v3.^2);

A = [ (f1.*v3 - f3.*v1 - v2.*(f1-f3) + f2.*(v1-v3)) ...
      (f3.*u1 - f1.*u3 + u2.*(f1-f3) - f2.*(u1-u3)) ];
b = -[v2.*(f1.*u3-f3.*u1) - u2.*(f1.*v3-f3.*v1) + f2.*(u1.*v3-u3.*v1)];

cc = A\b;

M = { cc };
