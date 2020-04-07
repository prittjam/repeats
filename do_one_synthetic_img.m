function [model_list,res_list,stats_list] = do_one_synthetic_img(solver,varargin)
cfg = struct('nx', 1000, ...
             'ny', 1000, ...
             'cc', [], ...
             'q', -4, ...
             'rigidxform', 'Rt', ...
             'numscenes', 1000, ...
             'ccdsigmalist', [0 0.1 0.5 1 2 5], ...
             'normqlist',-4);

if isempty(cfg.cc)
    cc = [cfg.nx/2+0.5; ...
          cfg.ny/2+0.5];
else
    cc = cfg.cc;
end    

f = 5*rand(1)+3;
cam = CAM.make_ccd(f,4.8,cfg.nx,cfg.ny);
P = PLANE.make_viewpoint(cam);

[X,G] = make_random_scene();

X3 = reshape(X,3,[]);
x = PT.renormI(P*X3);
q_gt = cfg.q/(sum(2*cc)^2);
xd = CAM.rd_div(reshape(x,3,[]),...
                cam.cc,q_gt);
xdn = reshape(GRID.add_noise(xd,1),9,[]); 

ransac = make_ransac(WRAP.lafmn_to_qAl(solver), ...
                     xdn,G,varargin{:});

[model_list,res_list,stats_list] = ransac.fit(xdn,cc,G);

function [X,G] = make_random_scene(varargin)
cfg = struct('inlier_ratio',0.5);
N = 5
X = [];
G = [];
for k = 1:N
    [X1,~,G1] = PLANE.make_cspond_set_t(100,10,10);
    X = cat(2,X,X1);
    if ~isempty(G)
        G = cat(2,G,G1+G(end));
    else
        G = G1;
    end
end

tmp = rand(1,size(X,2));
cs = tmp > cfg.inlier_ratio;
num_outliers = sum(cs);
Y = PLANE.make_outliers(num_outliers,10,10);
X(:,cs) = Y;