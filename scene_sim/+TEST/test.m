syms l1 l2 l3 u1 u2 u3 a 
l = transpose([l1 l2 l3]);
u = transpose([u1 u2 u3]);

H = [eye(3)+u*transpose(l)]

x = sym('x',[1 2]);
y = sym('y',[1 2]);

X = [x;y;sym(ones(1,2))];
expr = H(3,:)*X(:,1)*X(1:2,2)-H(1:2,:)*X(:,1) == sym(zeros(2,1))
cexpr = collect(expr,[u1 u2 u3])
 
 (- l3 - l1*x1 - l2*y1)*u1 + x2*(l3 + l1*x1 + l2*y1)*u3 + x2 - x1 == 0
 (- l3 - l1*x1 - l2*y1)*u2 + y2*(l3 + l1*x1 + l2*y1)*u3 + y2 - y1 == 0
