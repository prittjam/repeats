%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [img,si_fn] = render_scale_change(sz,l,cc,q,x)
nx = sz(2);
ny = sz(1);

l = PT.renormI(l);

cartesian = make_change_of_scale_constraints();

if q == 0
    si_fn = cartesian.si10_fn;
else
    si_fn = cartesian.si_fn;
end

[u,v] = meshgrid(1:nx,1:ny);
z = [u(:)'-0.5; ...
     v(:)'-0.5; ...
     ones(1,numel(u))];

if q == 0
    sc = si_fn(l(1),l(2),1,z(1,:),z(2,:));
else
    A = [1 0 -cc(1); ...
         0 1 -cc(2); ...
         0 0      1];
    zn = A*z;
    ln = PT.renormI(inv(A)'*l);
    sc = si_fn(1,ln(1),ln(2),q,1,zn(1,:),zn(2,:));
end

if nargin > 4
    x = reshape(x,3,[]);
    if size(x,2) > 1
%        Hinf = eye(3);
%        Hinf(3,:) = transpose(l);
%        xp =  PT.renormI(Hinf*CAM.ru_div(x,cc,q));
        idx = convhull(x(1,:),x(2,:));
        %        idx = convhull(xp(1,:),xp(2,:));
%        mux = mean(xp(:,idx),2);
%        refpt = CAM.rd_div(PT.renormI(Hinf \ mux),cc,q);
        refpt = mean(x(:,idx),2);
    else
        refpt = x;
    end  
    
    if q == 0
        ref_sc = si_fn(l(1),l(2),1,refpt(1),refpt(2));
    else
        A = [1 0 -cc(1); ...
             0 1 -cc(2); ...
             0 0      1];
        ptn = A*refpt;        
        ln = PT.renormI(inv(A)'*l);
        ref_sc = si_fn(1,ln(1),ln(2),q,1,ptn(1),ptn(2));
    end
end

sc = sc/ref_sc;

img = reshape(sc,ny,nx);