%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function Y = add_noise(X,arc_list,varargin)
cfg.sigma = 0;
cfg = cmp_argparse(cfg,varargin{:});

if cfg.sigma > 0
    for k = 1:numel(X);
        xx = X{k};
        n = xx(1:2,:)-arc_list(k).c;
        n = n ./ sqrt(sum(n.^2));
        s = normrnd(0,cfg.sigma,1,size(n,2));
        Y{k} = [xx(1:2,:)+s.*n;ones(1,size(xx,2))];
    end
else
    Y = X;
end
