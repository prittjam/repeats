function [score weights] = orsa_objective_fn(C,u,s,sample,cfg)
n = size(C,2);

N = [cfg.orsa.N1 cfg.orsa.N2];
[maxC,ind1] = max([sqrt(sum(C(1:2,:).^2)); ...
                   sqrt(sum(C(3:4,:).^2))]);

[smaxC,ind2] = sort(maxC,'ascend');
logalpha0 = N(ind1(ind2));
logalpha = logalpha0+log10(smaxC);
e = inf(size(logalpha));

kk = [cfg.k+1:n];

e(kk) = cfg.orsa.loge0+cfg.orsa.logcombi_n(kk)+ ...
        cfg.orsa.logcombi_k(kk)+logalpha(kk).*(kk-cfg.k);
[min_e,ind4] = min(e);

score = -min_e;

weights = zeros(size(maxC));
weights(ind2(1:ind4)) = 1;