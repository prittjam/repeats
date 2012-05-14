function s = pt_is_ideal(u,tol)

if nargin < 2
    tol = pi/180/2;
end

un = renorm(u);
s = abs(acos(un(3,:))) < pi/2-tol;