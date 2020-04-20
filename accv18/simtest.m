function [] = simtest
clear all;
greedy_repeats_init('..');
nx = 1000;
ny = 1000;
cc = [nx/2+0.5; ...
      ny/2+0.5];
w = 10;
h = 10;
[num_scenes,ccd_sigma_list,q_gt_list] = make_experiments(cc);
rel_diff = @(s1,s2) 2*abs(s1-s2)/(abs(s1)+abs(s2));
solver = WRAP.lafmxn_to_qAl(WRAP.laf3x2_to_ql(cc));

for scene_num = 1:num_scenes
    f = 5*rand(1)+3;
    cam = CAM.make_ccd(f,4.8,nx,ny);
    [P,xr] = PLANE.make_viewpoint(cam,10,10);
    X = [PLANE.make_cspond_same_Rt(2,w,h) ...
         PLANE.make_cspond_same_Rt(2,w,h) ...
         PLANE.make_cspond_same_Rt(2,w,h) ...
         PLANE.make_cspond_same_Rt(2,w,h)];
    for q_gt = q_gt_list
        for ccd_sigma = ccd_sigma_list
            gt = PLANE.make_gt(scene_num,P,q_gt, ...
                               cam.cc,ccd_sigma,X);
            X4 = reshape(X,4,[]); 
            x = PT.renormI(P*X4);
            xd = CAM.rd_div(x,cam.cc,q_gt);
            xdlaf = reshape(xd,9,[]);
            Gsamp = [1*ones(1,4) 2*ones(1,4) ...
                     3*ones(1,4) 4*ones(1,4)];
            Gapp = Gsamp;
            LAF.draw_groups(gca,reshape(xdlaf,9,[]),Gsamp);
            axis ij;
            axis equal;
            corresp = reshape([1:16],2,[]);
            M = solver.fit({xdlaf},{corresp},[1 3 5],Gsamp,Gapp);
            [model_list,lo_res_list,stats_list,cspond] = ...
                fit_coplanar_patterns(solver,xdlaf,Gsamp,Gapp,cc,1);
            
            if ~isempty(M)
                gt.l = gt.l/gt.l(3);
                res = inf(numel(M),3);
                res2 = inf(numel(M),3);

                sk = zeros(numel(M),6);
                sk2 = zeros(numel(M),6);
                for k = 1:numel(M)
                    for k2 = 1:6
                        sk(k,k2) = calc_constraints(xd(:,3*(k2-1)+1:3*k2), ...
                                                    M(k).q,M(k).l,cc);

                    end
                    sk2(k,:) = calc_geom_scale(xd,M(k).q,M(k).l,cc);
                    res(k,:) = [rel_diff(sk(k,1),sk(k,2)) ...
                                rel_diff(sk(k,3),sk(k,4)) ...
                                rel_diff(sk(k,5),sk(k,6))];
                    res2(k,:) = [rel_diff(sk2(k,1),sk2(k,2)) ...
                                 rel_diff(sk2(k,3),sk2(k,4)) ...
                                 rel_diff(sk2(k,5),sk2(k,6))];
                end
                
                gtsk = zeros(1,6);
                gtsk2 = zeros(1,6);
                for k2 = 1:6
                    gtsk(k2) = calc_constraints(xd(:,3*(k2-1)+1:3*k2), ...
                                                gt.q,gt.l,cc);
                    
                end
                gtsk2 = calc_geom_scale(xd,gt.q,gt.l,cc);
                resgt = [rel_diff(gtsk(1),gtsk(2)) ...
                         rel_diff(gtsk(3),gtsk(4)) ...
                         rel_diff(gtsk(5),gtsk(6))];
                resgt2 = [rel_diff(gtsk2(1),gtsk2(2)) ...
                          rel_diff(gtsk2(3),gtsk2(4)) ...
                          rel_diff(gtsk2(5),gtsk2(6))];
                
                d2 = min(pdist2(gt.l',[M(:).l]'));
                [opt_warp,best_ind] = calc_opt_res(gt,cam,M,P,w,h);    
                xd_laf = reshape(xd,9,[]);
            end
            if isempty(M) || d2 > 1e-5
                disp(['Failure! root is not a solution!']);
                disp(['opt_warp=' num2str(opt_warp)]);
                disp(['constraint rel. diffs (estimated)= ' num2str(res(best_ind,:))]);
                disp(['constraint rel. diffs (truth)    = ' num2str(resgt)]);
                figure;
                hold on;
                axis([1 1000 1 1000]);
                plot(xr(1,:),xr(2,:),'g');
                LAF.draw_groups(gca,xd_laf,[1 1 2 2 3 3]);
                LINE.draw_extents(gca,gt.l);
                hold off;          
                axis ij;
                axis square;
                keyboard;
            else
                disp(['Success']);
            end
           
        end
    end
end


function si = calc_constraints(xd,q,l,cc)
    A = [1 0 -cc(1); ...
         0 1 -cc(2); ...
         0 0  1];
    xx = A*xd;
    d = sum(xx(1:2,:).^2);
    ll = PT.renormI(inv(A')*l);
    a = transpose(ll)*[xx(1:2,:);1+q*d];        
    si = det([xx(1:2,:);a])/prod(a);
    
function sc = calc_geom_scale(xd,q,l,cc)
    A = [1 0 -cc(1); ...
         0 1 -cc(2); ...
         0 0  1];
    H = [1 0 0; ...
     0 1 0; ...
     transpose(l)];
xp = A*PT.renormI(H*CAM.ru_div(xd,cc,q));
sc = LAF.calc_scale(reshape(xp,9,[]));

function [num_scenes,ccd_sigma_list,q_list]  = make_experiments(cc)
    num_scenes = 1000;
    ccd_sigma_list = [0];
    q_list = arrayfun(@(x) x/(sum(2*cc)^2),-4);
%    q_list = 0;
 

function [opt_warp,best_ind] = calc_opt_res(gt,cam,M,P,w,h)    
    t = linspace(-0.5,0.5,10);
    [a,b] = meshgrid(t,t);
    x = transpose([a(:) b(:) ones(numel(a),1)]);
    M1 = [[w 0; 0 h] [0 0]';0 0 1];
    M2 = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
    X = M2*M1*x;
    Hinf = eye(3,3);
    Hinf(3,:) = transpose(gt.l);
    x = CAM.rd_div(PT.renormI(P*X),cam.cc,gt.q);
    warp_err_list = inf(1,numel(M));

    for k = 1:numel(M)
        warp_err_list = ...
            calc_bmvc16_err(x,gt.l,gt.q,M(k).l, ...
                            M(k).q,gt.cc);
    end
    [opt_warp,best_ind] = min(warp_err_list);
