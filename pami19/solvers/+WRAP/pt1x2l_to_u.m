function u = pt1x2l_to_u(x,l)
m = 2*size(x,2);
n = 3;

M = zeros(m,n);
b = zeros(m,1);

m11 = -l(3)-l(1)*x(1,:)-l(2)*x(2,:);
m12 = zeros(1,size(x,2));
m13 = x(4,:).*(l(3) + l(1)*x(1,:) + l(2)*x(2,:));
m21 = m12;
m22 = m11;
m23 = x(5,:).*(l(3) + l(1)*x(1,:) + l(2)*x(2,:));

M = [reshape([m11 m12 m13],[],3); ...
     reshape([m21 m22 m23],[],3)];

b1 = -x(4,:)+x(1,:);
b2 = -x(5,:)+x(2,:);

b = [b1 b2]';

c = [M'*b;0];

A = [M'*M l;
     l'   0];

u = A\c;
u = u(1:3);
%u2 = M\b;

%syms l1 l2 l3 u1 u2 u3 a 
%l = transpose([l1 l2 l3]);
%u = transpose([u1 u2 u3]);
%
%H = [eye(3)+u*transpose(l)]
%
%x = sym('x',[1 2]);
%y = sym('y',[1 2]);
%
%X = [x;y;sym(ones(1,2))];
%expr = H(3,:)*X(:,1)*X(1:2,2)-H(1:2,:)*X(:,1) == sym(zeros(2,1))
%cexpr = collect(expr,[u1 u2 u3])
% 
% (- l3 - l1*x1 - l2*y1)*u1 + x2*(l3 + l1*x1 + l2*y1)*u3 + x2 - x1 == 0
% (- l3 - l1*x1 - l2*y1)*u2 + y2*(l3 + l1*x1 + l2*y1)*u3 + y2 - y1 == 0
%