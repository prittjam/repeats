%%%%%%%
% sdi       are the measured scales of imaged regions, they are known   
% xi,yi     are the measured centroids of imaged regions, they are known
% si        is the rectified scale, it will be eliminated
% l1 l2 l3  are the components of vanishing line
% q         is the division model parameter
function [si18,tst18_fn,si10,tst10_fn] = make_change_of_scale_constraints()
clear all;
si18 = sym('s',[1 6]);
sdi = sym('sd',[1 6]);
xi = sym('x',[1 6]);
yi = sym('y',[1 6]);
ri = sym('r',[1 6]);
thetai = sym('theta',[1 6]);

syms r theta;

fxy = make_f();
vars = symvar(fxy);
syms(vars(:));
Jxy = jacobian(fxy,[x,y]);

fpolar = subs(fxy,[x,y],[r*cos(theta) r*sin(theta)]);
vars = symvar(fpolar);
syms(vars(:));
Jpolar = jacobian(fpolar,[r theta]);

%%%%% Because scale is an invariant of affine rectification, there are
% two choices: 
% 1.) set l3=1, which makes the vanishing line inhomogeneous and si
% becomes the unknown scale to be estimated, 
% 2.)  set si(1) = 1 only for the first correspondence, 
% and l3 is an unknown and to be estimated

Jxy = subs(Jxy,l3,1);
detJxy = det(Jxy);

Jpolar = subs(Jpolar,l3,1);
detJpolar = det(Jpolar);

for k = 1:6
    si18(k) = subs(detJxy,[x y],[xi(k) yi(k)])*sdi(k);
    si18polar(k) = subs(detJpolar,[r theta],[ri(k) thetai(k)])*sdi(k);
end

tst18_fn = matlabFunction(si18(1));

%%%%%%%%%%%%%%%%%%%%
% compare to accv10 constraints
si10 = make_accv10(si18);
tst10_fn = matlabFunction(si10(1));

keyboard;

function f = make_f()
syms x y l1 l2 l3 q;
X = transpose([x y 1+q*(x^2+y^2)]);
l = transpose([l1 l2 l3]);
f = [x/(transpose(l)*X), y/(transpose(l)*X)];

function invdetJ = make_invdetJ()

J = jacobian([x/(transpose(l)*X), y/(transpose(l)*X)],[x,y]);
invdetJ = 1/det(J);

function [si10,alphai] = make_accv10(si)
vars = symvar(si(1));
syms(vars(:));
for k = 1:4
    si10(k) = subs(si(k),q,0);
end