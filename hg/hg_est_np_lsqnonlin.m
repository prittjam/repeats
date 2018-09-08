%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function H = hg_est_np_lsqnonlin(u, sample_set, cfg, varargin)
H0 = cfg.model_args;

extract = @(H) H(1:8)/H(9);
wrap_err = @(h,u) hg_sampson_err(reshape([h 1],3,3),u);

h = lsqnonlin(wrap_err, extract(H0), [], [], ...
              optimset('Display', 'Off', ...
                       'Diagnostics', 'Off', ...
                       'MaxIter', 3), ...
              u(:,sample_set));

H = { reshape([h 1],3,3) };