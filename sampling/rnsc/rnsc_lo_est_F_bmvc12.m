function res = rnsc_lo_est_F_bmvc12(u,s,sample,weights,F0,cfg)

cfg8 = cfg;
cfg8.tsq = 4*cfg.tsq;
cfg8.objective_args = {4*cfg.tsq};

res8 = rnsc_get_best_model(u,s,[],F0,cfg8);
F8 = eg_est_F_from_8p(u,res8.weights > 0);

res8 = rnsc_get_best_model(u,s,[],F8,cfg);

ind = int32(find(res8.weights > 0))-1;

res = [];

sz = [cfg.sz1 cfg.sz2];

if numel(ind) > 16
    inlC = res8.C(:,res8.weights > 0);
    
    init.prior = zeros(1,2);
    init.mu = 0;
    init.Sigma = cov(inlC(:));
    init.prior(1) = numel(ind)/sum(s);
    init.prior(2) = 1-init.prior(1);
    init.U = 1./min(sz(:));
    
    [label, model, llh, R] = UGMM.ugmm_em(res8.C(:)',init,5);

    [opt_Ft,opt_weights] = innerloF(u,cfg.tsq,ind);

    opt_F = opt_Ft';

    if any(abs(opt_F(:)) > eps)
        res = rnsc_get_best_model(u,s,[],opt_F,cfg);
        res.weights = opt_weights;
        res.from_lo = true;
    else
        kkk = 3;
    end
else 
    kkk = 3;
end

function 