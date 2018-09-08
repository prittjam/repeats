%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [score weights] = orsa_objective_fn2(C,u,s,sample,cfg)
n = size(C,2);

weights = zeros(1,n);
score = -inf;

[maxC,ind1] = max([sum(C(1:2,:).^2); ...
                   sum(C(3:4,:).^2)]);
[smaxC,ind2] = sort(maxC,'ascend');

logalpha = cfg.orsa.logalpha0(ind1(ind2))+0.5*log10(smaxC);

ind3 = numel(ind2);

if ind3 > cfg.orsa.k
    kk = [cfg.orsa.k+1:ind3];
    e = inf(size(logalpha));
    e(kk) = cfg.orsa.loge0+cfg.orsa.logcombi_n(kk)+ ...
            cfg.orsa.logcombi_k(kk)+logalpha(kk).*(kk-cfg.orsa.k);
    figure;plot(e);
    [min_e,ind4] = max(find(e < 1));
    score = min_e;
    weights(ind2(1:ind4)) = 1;
end