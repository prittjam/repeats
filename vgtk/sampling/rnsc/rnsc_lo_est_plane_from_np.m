%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function res = rnsc_lo_est_plane_from_np(u,sample_set,n0,cfg)
res = rnsc_get_best_model(u,{ n0 },cfg);
cfg.s = min([floor(sum(res.weights)/2) 14]);

if cfg.s > 3
    cfg.est_args = { n0 };
    res = rnsc_estimate(u,sample_set,cfg);
end