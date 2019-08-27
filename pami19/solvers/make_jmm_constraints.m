%
% Inputs:
%
% X         are the measured point parameterizations of imaged
%             region, they are known
% l1 l2 l3  are the components of vanishing line
% q         is the division model parameter
%
%
% Outputs:
%
% J         constraint equations 
% Jfn       incidence constraints as a Matlab objective function 
%
function [J,Jfn,coeffs_q] = make_jmm_constraints()
clear all
syms l1 l2 l3 q;
Hinf = sym(eye(3)); 
syms tx ty;
% 1.) set l3=1, which makes the vanishing line inhomogeneous 
l3 = 1;
l = transpose([l1 l2 l3]);
t = transpose([tx ty 0]);
Hinf(3,:) = transpose([l1 l2 l3]);
x = sym('x',[1 6]);
y = sym('y',[1 6]);
X = [x;y;sym(ones(1,6))];
J = make_constraints(X,l,q);
J(end) = simplify(J(end));
J(end) = collect(J(end),q);
coeffs_q = coeffs(J(end),q);
keyboard;

res = solve(J(end),q,'MaxDegree', 4);

keyboard;
%coeffs_qfn = matlabFunction(coeffs_q);
%
Jfn = matlabFunction(J(1));
%Jfn2 = matlabFunction(J(end));

function J = make_constraints(X,l,q)
X(3,:) = 1+q*(sum(X(1:2,:).^2));
idx = nchoosek([1 2 3],2);
v = sym(zeros(3,3));
for k = 1:size(idx,1)
    m1 = cross(X(:,idx(k,1)), ...
               X(:,idx(k,2)));
    m2 = cross(X(:,3+idx(k,1)), ...
               X(:,3+idx(k,2))); 
    v(:,k) = cross(m1,m2); 
end
M = transpose(v);
J = [M*l;det(M)];