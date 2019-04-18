%%%%%%%
% X         are the measured point parameterizations of imaged
%             region, they are known
% si        is the rectified scale
% l1 l2 l3  are the components of vanishing line
% q         is the division model parameter
function [si,si_fn,sij_alg_err_fn] = make_closed_form_constraints()
clear all
syms l1 l2 l3 q;
Hinf = sym(eye(3)); 
%%%%% Because scale is an invariant of affine rectification, there are
% two choices: 
% 1.) set l3=1, which makes the vanishing line inhomogeneous and si
% becomes the unknown scale to be estimated, 
% 2.)  set si(1) = 1 only for the first correspondence, and l3 is an
% unknown and to be estimated
l3 = 1;
%si(1) = 1;
Hinf(3,:) = transpose([l1 l2 l3]);
x = sym('x',[1 18]);
y = sym('y',[1 18]);
X = [x;y;sym(ones(1,18))];

for k = 1:6
    si(k) = make_constraint(X(:,3*(k-1)+1:3*k),Hinf,q);
end

si_fn = matlabFunction(si(1));

[a1,b1] = numden(si(1));
[a2,b2] = numden(si(2));
alg_err = a1*b2-a2*b1;

sij_alg_err_fn = matlabFunction(alg_err);

function si = make_constraint(X,Hinf,q)
X(3,:) = 1+q*(sum(X(1:2,:).^2));
Xp = Hinf*X;
si = (Xp(3,1)*det(X(1:2,2:3))-Xp(3,2)*det(X(1:2,[1 3]))+... 
      Xp(3,3)*det(X(1:2,1:2)))/prod(Xp(3,:))/2;