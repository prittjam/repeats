function [model_list,res_list,stats_list,...
          opt_xfer_list,opt_warp_list] = do_one_synthetic_img(solver,varargin)
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

wplane = 10;
hplane = 10;
f = 5*rand(1)+3;
cam = CAM.make_ccd(f,4.8,cfg.nx,cfg.ny);
P = PLANE.make_viewpoint(cam);
q_gt = cfg.q/(sum(2*cc)^2);
[X,G] = make_random_scene();
truth = PLANE.make_Rt_gt(1,P,q_gt,cam.cc,1);

X3 = reshape(X,3,[]);
x = PT.renormI(P*X3);

xd = CAM.rd_div(reshape(x,3,[]),...
                cam.cc,q_gt);
xdn = reshape(GRID.add_noise(xd,1),9,[]); 
ransac = make_ransac(WRAP.lafmn_to_qAl(solver), ...
                     xdn,G,varargin{:});

[model_list,res_list,stats_list] = ransac.fit(xdn,cc,G);
global_models = [stats_list.global_list(:).model];
trial_counts = [stats_list.global_list(:).trial_count]; 
assert(numel(trial_counts)==numel(global_models));

for k = 1:numel(global_models)
    opt_xfer_list(k) = ...
        calc_opt_xfer(truth,reshape(x,9,[]), ...
                      global_models(k),P,wplane,hplane);
    opt_warp_list(k) = ...
        calc_opt_warp(truth, ...
                      global_models(k),P,wplane,hplane);
end

function [X,G] = make_random_scene(varargin)
cfg = struct('inlier_ratio',0.5);
N = 15;
X = [];
G = [];
for k = 1:N
    [X1,~,G1] = PLANE.make_cspond_set_t(40,10,10);
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

function opt_xfer = calc_opt_xfer(gt,xu,M,P,w,h) 
    xu = reshape([xu(1:3,1:2) xu(4:6,1:2) xu(7:9,1:2)],6,[]);
    U = PT.renormI(P\[xu(1:3,1) xu(4:6,1)]);
    dU = U(:,2)-U(:,1);
    normu = norm(dU);

    T = eye(3);
    T(1:2,3) = dU(1:2)/norm(dU);

    t = linspace(-0.5,0.5,10);
    [a,b] = meshgrid(t,t);

    M1 = [[w 0; 0 h] [0 0]';0 0 1];
    X = M1*transpose([a(:) b(:) ones(numel(a),1)]);
    Xp = T*X;
    
    if isfield(M,'q1')
        mq = mean([[M(:).q1]; ...
                   [M(:).q2]]);
    elseif isfield(M,'q')
        mq = [M(:).q];
    else
        mq = nan(1,numel(M));
    end 
    
    xd = PT.rd_div(PT.renormI(P*X),gt.cc,gt.q);
    xdp = PT.rd_div(PT.renormI(P*Xp),gt.cc,gt.q);
 
    xfer_list = nan(1,numel(M));
    opt_xfer = nan;

    if ~isfield(M,'Hu')
        u = nan(3,numel(M));
        Hu = nan(3,3,numel(M));
        for k = 1:numel(M)
            u(:,k) = pt1x2l_to_u(xu,M(k).l);
            Hu(:,:,k) = [eye(3)+u(:,k)*M(k).l'];
            H = eye(3)+(Hu(:,:,k)-eye(3))/normu;
            x2d = PT.rd_div(PT.renormI(H*PT.ru_div(xd,gt.cc,M(k).q)),gt.cc,M(k).q);
            err = x2d(1:2,:)-xdp(1:2,:);
            xfer_list(k) = rms(err(:));
        end                    
    else
        for k = 1:numel(M)
            H1 = eye(3)+(M(k).Hu-eye(3))/normu;
            H2 = mpower(M(k).Hu,1/normu);

            x2d1 = PT.rd_div(PT.renormI(H1*PT.ru_div(xd,gt.cc, ...
                                                     M(k).q)),gt.cc,M(k).q);
            x2d2 = PT.rd_div(PT.renormI(H2*PT.ru_div(xd,gt.cc, ...
                                                     M(k).q)),gt.cc,M(k).q);
            
            erra = x2d1(1:2,:)-xdp(1:2,:);
            errb = x2d2(1:2,:)-xdp(1:2,:);
            xfer_list(k) = min([rms(erra(:)) rms(errb(:))]);
        end
    end

    [opt_xfer,best_ind] = min(xfer_list);    
   
function [opt_warp,optq] = calc_opt_warp(gt,M,P,w,h)    
    t = linspace(-0.5,0.5,10);
    [a,b] = meshgrid(t,t);
    x = transpose([a(:) b(:) ones(numel(a),1)]);
    M1 = [[w 0; 0 h] [0 0]';0 0 1];
    X = M1*x;
    x = CAM.rd_div(PT.renormI(P*X),gt.cc,gt.q);

    if isfield(M,'q1')
        mq = ([M(:).q1]+[M(:).q2])/2;
    elseif isfield(M,'q')
        mq = [M(:).q];
    else
        mq = nan(1,numel(M));
    end    

    warp_list = nan(1,numel(M));
    optq = nan;
    opt_warp = nan;
    if isfield(M,'l')
        for k = 1:numel(M)
            warp_list(k) = ...
                TEST.calc_warp_err(x,gt.l,gt.q,M(k).l,mq(k),gt.cc);
        end
    elseif isfield(M(1),'Hu')
%        for k = 1:numel(M)
%            [U,S,V] = svd(M(k).Hu-eye(3));
%            S(2,2) = 0;
%            S(3,3) = 0;
%            projH = U*S*transpose(V);
%            warp_list(k) = ...
%                TEST.calc_warp_err(x,gt.l,gt.q,transpose(projH(3,:)),mq(k),gt.cc);
%        end
    end

    [opt_warp,best_ind] = min(warp_list);    
    optq = mq(best_ind); 