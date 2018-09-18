%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = sensitivity(out_name,name_list,solver_list,varargin)
    repeats_init;
    assert(numel(name_list) == numel(solver_list), ...
           'The number of names MUST match the number of solvers');
    
    cfg = struct('nx', 1000, ...
                 'ny', 1000, ...
                 'cc', [], ...
                 'rigidxform', 'Rt', ...
                 'numscenes' = 1000, ...
                 'ccdsigmalist', [0 0.1 0.5 1 2 5], ...
                 'normqlist',-4);
        
    cfg = cmp_argparse(cfg,varargin{:});

    q_list = arrayfun(@(x) x/(sum(2*cc)^2),cfg.normqlist);
    
    if isempty(cfg.cc)
        cc = [cfg.nx/2+0.5; ...
              cfg.ny/2+0.5];
    else
        cc = cfg.cc;
    end
    
    samples_drawn = 25;

    wplane = 10;
    hplane = 10;

    res = cell2table(cell(0,6), 'VariableNames', ...
                     {'solver','ex_num','rewarp',...
                      'ransac_rewarp','q','ransac_q'});
    gt = cell2table(cell(0,4), 'VariableNames', ...
                    {'ex_num', 'scene_num', 'q_gt','sigma'});

    sample_type_strings = ...
        {'laf2','laf22','laf22s','laf222','laf32','laf4'};
    sample_type_list = categorical(1:numel(sample_type_strings),...
                                   1:numel(sample_type_strings), ...
                                   sample_type_strings, ...
                                   'Ordinal',true);
    solver_names = categorical([1:numel(name_list)], ...
                               [1:numel(name_list)], ...
                               name_list, 'Ordinal', true);
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
                    PLANE.sample_cspond(usample_type{k},'RigidXform',cfg.rigidxform);
            end
            cspond_dict(usample_type{k}) = ...
                struct('Xlist', Xlist, 'idx', idx, 'G', G);                
        end

        clear idx;
        for q_gt = q_gt_list
            for ccd_sigma = cfg.ccdsigmalist
                for k = 1:numel(solver_list)
                    optq_list = nan(1,samples_drawn);
                    opt_warp_list = nan(1,samples_drawn);
                    cspond_info = ...
                        cspond_dict(solver_sample_type{k});
                    for k2 = 1:samples_drawn
                        X = cspond_info(k2).Xlist;
                        truth = PLANE.make_Rt_gt(scene_num,P,q_gt,cam.cc,ccd_sigma);
                        X4 = reshape(X,4,[]);
                        x = PT.renormI(P*X4);
                        xd = CAM.rd_div(reshape(x,3,[]),...
                                        cam.cc,q_gt);
                        xdn = ...
                            reshape(GRID.add_noise(xd,ccd_sigma), ...
                                    9,[]);       
                        try
                            M = ...
                                solver_list(k).fit(xdn,[],cspond_info(k2).idx,cc);
                        catch err
                            M = [];
                        end
                        
                        if ~isempty(M)
                            [~,opt_warp_list(k2)] = ...
                                calc_opt_warp(truth,cam,M,P,wplane,hplane);
                            optq_list(k2) = ...
                                calc_opt_q(truth,cam,M,P,wplane,hplane);
                        else
                            disp(['solver failure for ' name_list{k}]);
                        end
                    end
                    [~,best_ind] = min(opt_warp_list);
                    [~,optq_ind] = min(abs(optq_list-truth.q));
                    ind = find(~isnan(optq_list),1);
                    res_row = { solver_names(k), ex_num, ...
                                opt_warp_list(ind), opt_warp_list(best_ind), ...
                                optq_list(ind), optq_list(optq_ind) };
                    tmp_res = res;
                    res = [tmp_res;res_row]; 
                end
                gt_row = ...
                    { ex_num, scene_num, q_gt, ccd_sigma };
                gt = [gt;gt_row];

                disp(['Computing ex number ' num2str(ex_num)]);
                ex_num = ex_num+1;
            end
        end
        keyboard;
    end
    disp(['Finished']);
    save(out_name,'res','gt','cam');


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
    if isfield(M(1),'l')
        for k = 1:numel(M)
            warp_list(k) = ...
                calc_bmvc16_err(x,gt.l,gt.q,M(k).l,mq(k),gt.cc);
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