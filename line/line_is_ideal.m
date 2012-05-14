function s = line_is_ideal(u,tol)

if nargin < 2
    tol = pi/180/2;
end

un = renorm(u);
s = acos(un(3,:)) < tol;