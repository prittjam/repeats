% Copyright (c) 2017 James Pritts
% 
function gt = make_gt(scene,scene_num,cam,P,q,ccd_sigma,cc)
rows = [1 1 2 2];
cols = [1 2 1 2];

m = [scene(:).rows; ...
     scene(:).cols]';
[~,ind] = ismember([rows;cols]',m,'rows'); 

x = PT.renormI(P*[scene(ind([1 2])).X scene(ind([3 4])).X]);

[xn,A] = normalize(x,cam);

l1 = cross(xn(:,1),xn(:,2));
l2 = cross(xn(:,3),xn(:,4));
l3 = cross(xn(:,1),xn(:,3));
l4 = cross(xn(:,2),xn(:,4));

v = cross(l1,l2);
w = cross(l3,l4);

linf = cross(v,w);
linf = PT.renormI(linf/linf(3));
linf = PT.renormI(A'*linf);

gt = struct('l', linf, ...
            'u', v, ...
            'scene_num', scene_num, ...
            'q', q, ...
            'ccd_sigma', ccd_sigma, ...
            'num_scene_pts', size([scene(:).X],2), ...
            'cc',cc);

function [xn,A] = normalize(x,cam)
sc = sum(2*cam.cc);
ncc = -cam.cc/sc;
A = [1/sc 0        ncc(1); ...
     0       1/sc  ncc(2); ...
     0       0      1];
xn = A*x;
