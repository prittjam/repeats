%%%%%%%
% Knowns
% sdi       are the measured scales of imaged regions, they are known   
% xi,yi     are the measured centroids of imaged regions, they are known
% ci        constants from the previous iteration that
%           enables iterative estimation of radial distortion. For
%           the first iteration ci=1; they are known. 
%
% Unknowns
% si        is the rectified scale, it will be eliminated
% l1 l2 l3  are the components of vanishing line
% q         is the division model parameter

function cartesian = make_change_of_scale_constraints(varargin)
clear all;
si = sym('s',[1 6]);
sdi = sym('sd',[1 6]);
xi = sym('x',[1 6]);
yi = sym('y',[1 6]);
ci = sym('c',[1 6]);

fxy = make_f();
vars = symvar(fxy);
syms(vars(:));
Jxy = jacobian(fxy,[x,y]);

%%%%% Because scale is an invariant of affine rectification, there are
% two choices: 
% 1.) set l3=1, which makes the vanishing line inhomogeneous and si
% becomes the unknown scale to be estimated, 
% 2.)  set si(1) = 1 only for the first correspondence, 
% and l3 is an unknown and to be estimated

Jxy = subs(Jxy,l3,1);
detJxy = det(Jxy);
for k = 1:6
    si(k) = subs(detJxy,[c x y],[ci(k) xi(k) yi(k)])*sdi(k);
end
%%%%%%%%%%%%%%%%%%%%
% compare to accv10 constraints
si10 = make_accv10(si);

%%%%%%%%%%%%%%%%%%%%
% Make MATLAB functions for testing constraints
si_fn = matlabFunction(si(1));
si10_fn = matlabFunction(si10(1));

cartesian = struct('si', si, ...
                   'si_fn', si_fn, ...
                   'si10', si10, ...
                   'si10_fn', si10_fn);

function f = make_f()
syms c x y l1 l2 l3 q;
X = transpose([x y c+q*(x^2+y^2)]);
l = transpose([l1 l2 l3]);
f = [X(1)/(transpose(l)*X), X(2)/(transpose(l)*X)];

function [si10,alphai] = make_accv10(si)
for k = 1:4
    vars = symvar(si(k));
    syms(vars(:));
    si10(k) = subs(si(k),[vars(1) q],[1 0]);
end