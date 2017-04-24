% Copyright (c) 2017 James Pritts
% 
function gt = make_grid_gt(scene,scene_num,cam,P,lambda,ccd_sigma)
rows = [1 1 2 2];
cols = [1 2 1 2];

m = [scene(:).rows; ...
     scene(:).cols]';
[~,ind] = ismember([rows;cols]',m,'rows'); 

u = PT.renormI(P*[scene(ind([1 2])).X scene(ind([3 4])).X]);

[un,A] = normalize(u,cam);

l1 = cross(un(:,1),un(:,2));
l2 = cross(un(:,3),un(:,4));
l3 = cross(un(:,1),un(:,3));
l4 = cross(un(:,2),un(:,4));

v = cross(l1,l2);
w = cross(l3,l4);

linf = cross(v,w);
linf = PT.renormI(linf/linf(3));
linf = PT.renormI(A'*linf);

gt = struct('linf', linf, ...
            'v', v, ...
            'scene_num', scene_num, ...
            'lambda', lambda, ...
            'ccd_sigma', ccd_sigma, ...
            'num_scene_pts', size([scene(:).X],2));

function [un,A] = normalize(u,cam)
sc = sum(2*cam.cc);
ncc = -cam.cc/sc;
A = [1/sc 0        ncc(1); ...
     0       1/sc  ncc(2); ...
     0       0      1];
un = A*u;

