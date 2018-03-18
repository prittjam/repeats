function [] = sensitivity(out_name,varargin)
    greedy_repeats_init('..');
    samples_drawn = 25;
    nx = 1000;
    ny = 1000;
    cc = [nx/2+0.5; ...
          ny/2+0.5];
    wplane = 10;
    hplane = 10;
    [num_scenes,ccd_sigma_list,q_gt_list] = make_experiments(cc);
    res = cell2table(cell(0,6), 'VariableNames', ...
                     {'solver','ex_num','rewarp',...
                      'ransac_rewarp','q','ransac_q'});
    gt = cell2table(cell(0,4), 'VariableNames', ...
                    {'ex_num', 'scene_num', 'q_gt','sigma'});

    sample_type_strings = {'laf2','laf22','laf22s','laf222','laf32','laf4'};
    sample_type_list = categorical(1:6,1:6, ...
                                   sample_type_strings, ...
                                   'Ordinal',true);
    name_list = {'$\mH2\vl\vu s_{\vu}\lambda$', ...
                 '$\mH22\vl\vu\vv s_{\vv}\lambda$', ...
                 '$\mH22\vl s$', ...
                 '$\mH22\lambda$', ...
                 '$\mH222\vl\lambda s_i$', ...
                 '$\mH32\vl\lambda s_i$', ...
                 '$\mH4\vl\lambda s_i$'}; 
    
    solver_names = categorical([1:numel(name_list)], ...
                               [1:numel(name_list)], ...
                               name_list, 'Ordinal', true);
    solver_list = [ ...
        WRAP.laf2_to_qlsu(cc) ...
        WRAP.laf22_to_qlusv(cc) ...
        WRAP.laf22_to_Hinf() ...
        WRAP.laf22_to_qH(cc) ...
        WRAP.laf222_to_ql(cc) ...
        WRAP.laf32_to_ql(cc) ...
        WRAP.laf4_to_ql(cc) ] ;
    
    solver_sample_type = {'laf2', 'laf22', 'laf22', ...
                        'laf22s', 'laf222', 'laf32', 'laf4'};
    ex_num = 1;

    for scene_num = 1:num_scenes
        f = 5*rand(1)+3;
        cam = CAM.make_ccd(f,4.8,nx,ny);
        P = PLANE.make_viewpoint(cam,10,10);
        cspond_dict = containers.Map;
        usample_type = unique(solver_sample_type);
        for k = 1:numel(usample_type)
            Xlist = {};
            cspond = {};
            G = {};
            for k2 = 1:samples_drawn
                [Xlist{k2},cspond{k2},G{k2}] = sample_lafs(usample_type{k},...
                                                           wplane,hplane);
            end
            cspond_dict(usample_type{k}) = struct('Xlist', Xlist, ...
                                                  'cspond', cspond, ...
                                                  'G', G);                
        end
        for q_gt = q_gt_list
            for ccd_sigma = ccd_sigma_list
                for k = 1:numel(solver_list)
                    optq_list = nan(1,samples_drawn);
                    opt_warp_list = nan(1,samples_drawn);
                    cspond_info = cspond_dict(solver_sample_type{k});
                    for k2 = 1:samples_drawn
                        X = cspond_info(k2).Xlist;
                        truth = PLANE.make_gt(scene_num,P,q_gt,cam.cc, ...
                                              ccd_sigma,X);
                        keyboard;
                        X4 = reshape(X,4,[]);
                        x = PT.renormI(P*X4);
                        xd = CAM.rd_div(reshape(x,3,[]),...
                                        cam.cc,q_gt);
                        xdn = ...
                            reshape(GRID.add_noise(xd,ccd_sigma), ...
                                    9,[]);
                        try
                            M = ...
                                solver_list(k).fit(xdn, ...
                                                   cspond_info(k2).cspond, ...
                                                   1:size(cspond_info(k2).cspond,2), ...
                                                   cspond_info(k2).G);
                        catch
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
                    idx = find(~isnan(optq_list),1);
                    res_row = { solver_names(k), ex_num, ...
                                opt_warp_list(idx), opt_warp_list(best_ind), ...
                                optq_list(idx), optq_list(optq_ind) };
                    res = [res;res_row]; 
                end
                gt_row = ...
                    { ex_num, scene_num, q_gt, ccd_sigma };
                gt = [gt;gt_row];
                ex_num = ex_num+1;
                disp(['Computing ex number ' num2str(ex_num)]);
            end
        end
    end
    disp(['Finished']);
    save('sensitivity','res','gt','cam');
%
function [num_scenes,ccd_sigma_list,q_list]  = make_experiments(cc)
    num_scenes = 1000;   
    ccd_sigma_list = [0.1 0.5 1 2 5];
    q_list = arrayfun(@(x) x/(sum(2*cc)^2),-4);
    
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
        mq = zeros(1,numel(M));
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

function [optq,opt_rms,opt_warp] = calc_opt_res(gt,cam,M,P,w,h)    
    t = linspace(-0.5,0.5,10);
    [a,b] = meshgrid(t,t);
    x = transpose([a(:) b(:) ones(numel(a),1)]);
    M1 = [[w 0; 0 h] [0 0]';0 0 1];
    M2 = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
    X = M2*M1*x;

    zu = floor(log2(gt.sU));
    zv = floor(log2(gt.sV));
    
    nthroot(gt.sU,zu);
    
    Hinf = eye(3,3);
    Hinf(3,:) = transpose(gt.l);
    Xu = X+[gt.U;0];
    Xv = X+[gt.V;0];
    
    x = CAM.rd_div(PT.renormI(P*X),cam.cc,gt.q);
    xu = CAM.rd_div(PT.renormI(P*Xu),cam.cc,gt.q);
    xv = CAM.rd_div(PT.renormI(P*Xv),cam.cc,gt.q);    
      
    if isfield(M,'q1')
        q1 = [M(:).q1];
        q2 = [M(:).q2];
    elseif isfield(M,'q')
        q1 = [M(:).q];
        q2 = q1;
    else
        q1 = zeros(1,numel(M));
        q2 = q1;
    end
    
    rms_list = zeros(1,numel(M));
    for k = 1:numel(M)
        df1 = [];
        df2 = [];
        for k2 = 1:2 
            H = [];
            if k2 == 1
                if isfield(M(k),'u')
                    H = eye(3)+1/gt.sU*M(k).u*M(k).l';
                elseif isfield(M(k),'Hu')
                    H = M(k).Hu^(1/gt.sU);
                end
                if ~isempty(H)
                    xp = CAM.rd_div(PT.renormI(H*CAM.ru_div(...
                        x,cam.cc,q2(k))),cam.cc,q1(k));
                    df1 = xp(1:2,:)-xu(1:2,:);
                end
            else
                if isfield(M(k),'v')
                    H = eye(3)+1/gt.sV*M(k).v*M(k).l';
                    xp = CAM.rd_div(PT.renormI(H*CAM.ru_div(...
                        x,cam.cc,q2(k))),cam.cc,q1(k));
                    df2 = xp(1:2,:)-xv(1:2,:);
                end
            end
        end
        diff = [df1(:);df2(:)];
        if ~isempty(diff)
            rms_list(k) = rms(diff);
        else
            rms_list(k) = nan;
        end
    end
    [opt_rms,best_ind] = min(rms_list);    
    
    mq = mean([q1;q2]);
    optq = mq(best_ind); 

    if isfield(M(best_ind),'l')
        opt_warp = ...
            calc_bmvc16_err(x,gt.l,gt.q, ...
                            M(best_ind).l,optq,gt.cc);
    else
        opt_warp = nan;
    end

function [X,cspond,G] = sample_lafs(sample_type,w,h)
    switch sample_type
      case {'laf2','laf22'}
        [X,cspond,G] = PLANE.make_cspond_t(2,w,h);
      case 'laf22s'
        [X,cspond,G] = PLANE.make_cspond_same_t(2,w,h);
      case 'laf222'
        [X,cspond,G] = PLANE.make_cspond_t(3,w,h);
      case 'laf32'
        [X0,cspond0,G0] = PLANE.make_cspond_set_t(3,w,h);
        [X1,cspond1,G1] = PLANE.make_cspond_set_t(2,w,h);
        X = [X0 X1];
        cspond = [cspond0 cspond1];
        G = [G0 G1];
      case 'laf4'
        [X,cspond,G] = PLANE.make_cspond_set_t(4,w,h);
    end
