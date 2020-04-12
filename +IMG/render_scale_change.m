%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [img,si_fn,refpt] = render_scale_change(sz,l,cc,q,x)
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
        Hinf = eye(3);
        Hinf(3,:) = transpose(l);
        xu = CAM.ru_div(x,cc,q);
        xp =  RP2.renormI(Hinf*xu);
        A = HG.pt3x2_to_A([RP2.renormI(Hinf \ reshape(xp,3,[])); ...
                           reshape(xu,3,[])]); 
        idx = convhull(xp(1,:),xp(2,:));
        mux = mean(xp(:,idx),2);
        refpt = CAM.rd_div(A*PT.renormI(Hinf \ mux),cc,q);
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
    
    alg_err_fn = matlabFunction(si(1)-si(2));
    
    %%%%%%%%%%%%%%%%%%%%
    % compare to accv10 constraints
    si10 = make_accv10(si);
    
    %%%%%%%%%%%%%%%%%%%%
    % Make MATLAB functions for testing constraints
    si_fn = matlabFunction(si(1));
    si10_fn = matlabFunction(si10(1));
    
    cartesian = struct('si', si, ...
                       'si_fn', si_fn, ...
                       'si_alg_err_fn', alg_err_fn, ...
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