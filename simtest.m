function [] = simtest()
cfg = struct('nx',1000, ...
             'ny',1000, ...
             'cc',[500.5 500.5]);
greedy_repeats_init();
cam = CAM.make_ccd(4.15,4.8,cfg.nx,cfg.ny);
pattern = SIM.random_coplanar_pattern();
scene = pattern.make();
P = SIM.make_grid_viewpoint(scene,cam);
cam.P = P;
x = PT.renormI(P*[scene(:).X]);
G = [scene(:).G];
G = findgroups(G(1:3:end));
x = reshape(x,9,[]);
ccd_sigma = 0.5;
xn = reshape(CAM.add_noise(reshape(x,3,[]),ccd_sigma),9,[]);
assert(all(LAF.is_right_handed(x)), ...
       ['There are left-handed affine frames']); 
dr = struct('u',mat2cell(xn,9,ones(1,size(x,2))), ...
            'Gapp',mat2cell(G,1,ones(1,size(x,2))));
greedy_repeats(dr,cam.cc,'t');

