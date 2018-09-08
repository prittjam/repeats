%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function arc_list = make(nx,ny,cc,q,varargin)
cfg.num_arcs = 3;
cfg.min_cc_dist = 0;

cfg = cmp_argparse(cfg,varargin{:});

o = zeros(2,cfg.num_arcs);
r = zeros(1,cfg.num_arcs);

k = 1;
while k <= cfg.num_arcs
    x = [ceil([nx;ny].*rand(2,2))];    
    [o(:,k),r(k)] = pt1x2qcc_to_circle(x,cc,q);
    r2 = sqrt(sum((o(:,k)-cc).^2));
    d = abs(r2-r(k));
    if d > cfg.min_cc_dist
        k = k+1;
    end
end

arc_list = struct('c',mat2cell(o,2,ones(1,cfg.num_arcs)), ...
                  'r',mat2cell(r,1,ones(1,cfg.num_arcs)));
