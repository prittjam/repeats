%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [res,gt,cam] = sensitivity(name_list,solver_list,all_solver_names,varargin)
    repeats_init;
    assert(numel(name_list) == numel(solver_list), ...
           'The number of names MUST match the number of solvers');
    
    cfg = struct('nx', 1000, ...
                 'ny', 1000, ...
                 'cc', [], ...
                 'rigidxform', 'Rt', ...
                 'numscenes', 1000, ...
                 'ccdsigmalist', [0 0.1 0.5 1 2 5], ...
                 'normqlist',-4, ...
                 'samplesdrawn', 25);

    cfg = cmp_argparse(cfg,varargin{:});

    if isempty(cfg.cc)
        cc = [cfg.nx/2+0.5; ...
              cfg.ny/2+0.5];
    else
        cc = cfg.cc;
    end    
    
    q_gt_list = arrayfun(@(x) x/(sum(2*cc)^2),cfg.normqlist);

    samples_drawn = cfg.samplesdrawn;

    wplane = 10;
    hplane = 10;

    res = cell2table(cell(0,9), 'VariableNames', ...
                     {'solver','ex_num','rewarp',...
                      'ransac_rewarp','q','ransac_q', ...
                      'num_sol','num_real','num_feasible'});
    gt = cell2table(cell(0,4), 'VariableNames', ...
                    {'ex_num', 'scene_num', 'q_gt','sigma'});

    sample_type_strings = ...
        {'laf2','laf22','laf22s','laf222','laf32','laf4'};

    sample_type_list = categorical(1:numel(sample_type_strings),...
                                   1:numel(sample_type_strings), ...
                                   sample_type_strings, ...
                                   'Ordinal',true);
    solver_names = categorical([1:numel(all_solver_names)], ...
                               [1:numel(all_solver_names)], ...
                               all_solver_names, 'Ordinal', true);
    solver_sample_type = arrayfun(@(x) x.sample_type,solver_list, ...
                                  'UniformOutput',false);
    
    ex_num = 1;
    
    for scene_num = 1:cfg.numscenes
        f = 5*rand(1)+3;
        cam = CAM.make_ccd(f,4.8,cfg.nx,cfg.ny);
        P = PLANE.make_viewpoint(cam);
        cspond_dict = containers.Map;
        usample_type = unique(solver_sample_type);

        for k = 1:numel(usample_type)
            Xlist = {};
            cspond = {};
            G = {};
            for k2 = 1:samples_drawn
                [Xlist{k2},cspond{k2},idx{k2},G{k2}] = ...
                    PLANE.sample_cspond(usample_type{k},10,10,'RigidXform',cfg.rigidxform);
            end
            cspond_dict(usample_type{k}) = ...
                struct('Xlist', Xlist, 'idx', idx, 'G', G);                
        end
        
        for q_gt = q_gt_list
            for ccd_sigma = cfg.ccdsigmalist
                for k = 1:numel(solver_list)
                    optq_list = nan(1,samples_drawn);
                    opt_warp_list = nan(1,samples_drawn);
                    opt_xfer_list = nan(1,samples_drawn);
                    num_sol = nan(1,samples_drawn);
                    num_real = nan(1,samples_drawn);
                    num_feasible = nan(1,samples_drawn);
                    cspond_info = ...
                        cspond_dict(solver_sample_type{k});
                    solver_success = false;
                    for k2 = 1:samples_drawn
                        X = cspond_info(k2).Xlist;
                        idx = cspond_info(k2).idx;
                        G = cspond_info(k2).G;
                        truth = PLANE.make_Rt_gt(scene_num,P,q_gt, ...
                                                 cam.cc,ccd_sigma);
                        X4 = reshape(X,4,[]);
                        x = PT.renormI(P*X4);
                        xd = CAM.rd_div(x,cam.cc,q_gt);
                        xdn = reshape(GRID.add_noise(xd,ccd_sigma), ...
                                      9,[]);       

                        try                           
                            M = solver_list(k).fit(xdn,idx,cc,G);
                        catch err
                            M = [];
                        end
                        
                        if ~isempty(M)
                            if isfield(M,'l')
                                [flag,rflag] = ...
                                    solver_list(k).is_model_good(xdn,idx,M,cc,G);
                                M = M(rflag);
                                num_sol(k2) = numel(M);
                                num_real(k2) = sum(rflag);
                                num_feasible(k2) = sum(flag);
                            end
                        end
                        
                        if ~isempty(M)
                            solver_success = true;
                            [~,opt_warp_list(k2)] = ...
                                calc_opt_warp(truth,cam,M,P,wplane,hplane);
                            optq_list(k2) = ...
                                calc_opt_q(truth,cam,M,P,wplane, ...
                                           hplane);
                            opt_xfer(k2) = calc_opt_xfer(truth,cam,reshape(x,9,[]),...
                                                         idx,M,P,wplane,hplane);
                        end
                    end
                    
                    if solver_success
                        [~,best_ind] = min(opt_warp_list);
                        [~,optq_ind] = min(abs(optq_list-truth.q));
                        ind = find(~isnan(optq_list),1);
                        res_row = { solver_names(find(strcmpi(name_list(k),categories(solver_names)))), ...
                                    ex_num, opt_warp_list(ind), opt_warp_list(best_ind), ...
                                    optq_list(ind), optq_list(optq_ind), ...
                                    num_sol, num_real, num_feasible };
                        tmp_res = res;
                        res = [tmp_res;res_row]; 
                    else
                        disp(['solver failure for ' name_list{k}]);
                    end
 
%                    csind = [];                   
%                    for k = 1:size(idx,2)
%                        csind = cat(1,csind,nchoosek(idx{k},2));
%                    end
                end
                
                gt_row = ...
                    { ex_num, scene_num, q_gt, ccd_sigma };
                gt = [gt;gt_row];
                
                disp(['Computing ex number ' num2str(ex_num) ' of ' ...
                      num2str(cfg.numscenes*numel(cfg.ccdsigmalist)*numel(q_gt_list))]);
                ex_num = ex_num+1;
            end
        end
    end
    disp(['Finished']);

function [opt_xfer] = calc_opt_xfer(gt,cam,xu,idx,M,P,w,h) 
    xu = reshape([xu(1:3,1:2) xu(4:6,1:2) xu(7:9,1:2)],6,[]);
    U = PT.renormI(P\[xu(1:3,1) xu(4:6,1)],4);
    dU = U(:,2)-U(:,1)
    normu = norm(dU);

    T = [eye(3) dU(1:3)/norm(dU);
         0 0 0 1];
    
    t = linspace(-0.5,0.5,10);
    [a,b] = meshgrid(t,t);

    M1 = [[w 0; 0 h] [0 0]';0 0 1];
    M2 = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
    X = M2*M1*transpose([a(:) b(:) ones(numel(a),1)]);
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
            keyboard;
            u(:,k) = WRAP.pt1x2l_to_u(xu,M(k).l);
            Hu(:,:,k) = [eye(3)+u(:,k)*M(k).l'];
            H = eye(3)+(Hu(:,:,k)-eye(3))/normu;
            x2d = PT.rd_div(PT.renormI(H*PT.ru_div(xd,gt.cc,M(k).q)),gt.cc,M(k).q);
            d2 = (x2d-xdp).^2
            xfer_list(k) = sqrt(mean(d2(:)));
        end                    
    else
        for k = 1:numel(M)
            H = eye(3)+(M(k).Hu-eye(3))/normu;
            x2d = PT.rd_div(PT.renormI(H*PT.ru_div(xd,cc,M(k).q)),gt.cc,M(k).q);
            d2 = (x2d-xdp).^2
            xfer_list(k) = sqrt(mean(d2(:)));
        end
    end
    
    [opt_xfer,best_ind] = min(xfer_list);    

    
function optq = calc_opt_q(gt,cam,M,P,w,h)
    if isfield(M,'q1')
        mq = ([M(:).q1]+[M(:).q2])/2;
    elseif isfield(M,'q')
        mq = [M(:).q];
    else
        mq = zeros(1,numel(M));
    end        
    [~,best_ind] = min(abs(mq-gt.q));
    optq = mq(best_ind);
    
function [optq,opt_warp] = calc_opt_warp(gt,cam,M,P,w,h)    
    t = linspace(-0.5,0.5,10);
    [a,b] = meshgrid(t,t);
    x = transpose([a(:) b(:) ones(numel(a),1)]);
    M1 = [[w 0; 0 h] [0 0]';0 0 1];
    M2 = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
    X = M2*M1*x;
    x = CAM.rd_div(PT.renormI(P*X),cam.cc,gt.q);

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
%            tmp = real(eig(M(k).Hu));
%            [U,S,V] = svd(M(k).Hu-tmp(1)*eye(3));
%            S(2,2) = 0;
%            S(3,3) = 0;
%            projH = U*S*transpose(V);
%            warp_list(k) = ...
%                calc_bmvc16_err(x,gt.l,gt.q,transpose(projH(3,:)),mq(k),gt.cc);
%        end
    end
    
    [opt_warp,best_ind] = min(warp_list);    
    optq = mq(best_ind); 