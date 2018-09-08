%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
% Copyright (c) 2017 James Pritts
% 
function gt = make_gt(scene_num,X,P,q_gt,cc,ccd_sigma)
H = P(:,[1 2 4]);
linf = inv(H)'*[0 0 1]';
gt = struct('l', linf, ...
            'scene_num', scene_num, ...
            'q', q_gt, 'ccd_sigma', ccd_sigma, ...
            'cc', cc);

%X = [scene(ind([1 2])).X scene(ind([3 4])).X];
%X = X(5:8,:);
%x = PT.renormI(P*X);
%
%[xn,A] = normalize(x,cam);
%
%l1 = cross(xn(:,1),xn(:,2));
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
