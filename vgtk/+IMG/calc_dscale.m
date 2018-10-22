%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [img,si_fn] = calc_dscale(dims,l,cc,q)
nx = dims(2);
ny = dims(1);

l = l/l(3);

cartesian = make_change_of_scale_constraints();

if q == 0
    si_fn = cartesian.si10_fn;
else
    si_fn = cartesian.si_fn;
end

[u,v] = meshgrid(1:nx,1:ny);
x = [u(:)'-0.5; ...
     v(:)'-0.5; ...
     ones(1,numel(u))];

if q == 0
    sc = si_fn(l(1),l(2),1,x(1,:),x(2,:));
else
    A = [1 0 -cc(1); ...
         0 1 -cc(2); ...
         0 0      1];
    xn = A*x;
    sc = si_fn(l(1),l(2),q,1,xn(1,:),xn(2,:));
end

img = reshape(sc,ny,nx);

