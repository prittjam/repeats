function s = line_is_ideal(u,tol)

if nargin < 2
    tol = 1e-5;
end

un = renorm(u);
s = acos(un(3,:)) < tol;