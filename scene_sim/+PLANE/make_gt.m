%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function gt = make_gt(scene_num,P,q_gt,cc,ccd_sigma,X)
H = P(:,[1 2 4]);
linf = inv(H)'*[0 0 1]';

H0 = [1 0 0 0; 0 1 0 0; 0 0 0 1];
Xlaf = blkdiag(H0,H0,H0)*X;

l1 = cross(Xlaf(1:3,1),Xlaf(1:3,2));
l2 = cross(Xlaf(4:6,1),Xlaf(4:6,2));
U = cross(l1,l2);
if dot(U,Xlaf(1:3,2)-Xlaf(1:3,1)) < 0
    U = -U;
end

u = PT.renormI(H*U);
su = norm(Xlaf(1:3,2)-Xlaf(1:3,1));

if size(X,2) > 2
    l3 = cross(Xlaf(1:3,3),Xlaf(1:3,4));
    l4 = cross(Xlaf(4:6,3),Xlaf(4:6,4));
    V = cross(l3,l4);
    if dot(V,Xlaf(1:3,4)-Xlaf(1:3,3)) < 0
        V = -V;
    end

    v = PT.renormI(H*V);
    sv = norm(Xlaf(1:3,4)-Xlaf(1:3,3));

    gt = struct('l', linf,'u', u, 'v', v, ...
                'sU', su,'sV', sv, ...
                'U',U/norm(U), 'V',V/norm(V), ...
                'scene_num', scene_num, ...
                'q', q_gt, 'ccd_sigma', ccd_sigma, ...
                'cc', cc);
else
    gt = struct('l', linf,'u', u, 'sU', su, ...
                'U',U/norm(U), 'scene_num', scene_num, ...
                'q', q_gt, 'ccd_sigma', ccd_sigma, ...
                'cc', cc);
end

%x1 = PT.renormI(H*Xlaf(1:3,1));
%x2 = PT.renormI(H*Xlaf(1:3,2));
%vvv = pt1x2_to_t([x1;x2],linf);
%keyboard;
%
%X = [scene(ind([1 2])).X scene(iund([3 4])).X];
%X = X(5:8,:);
%x = PT.renormI(P*X);
%
%[xn,A] = normalize(x,cam);
%

%l2 = cross(xn(:,3),xn(:,4));
%l3 = cross(xn(:,1),xn(:,3));
%l4 = cross(xn(:,2),xn(:,4));
%
%v = cross(l1,l2);
%w = cross(l3,l4);
%
%linf = cross(v,w);
%linf = PT.renormI(linf/linf(3));
%linf = PT.renormI(A'*linf);



%function [xn,A] = normalize(x,cam)
%sc = sum(2*cam.cc);
%ncc = -cam.cc/sc;
%A = [1/sc 0        ncc(1); ...
%     0       1/sc  ncc(2); ...
%     0       0      1];
%xn = A*x;
