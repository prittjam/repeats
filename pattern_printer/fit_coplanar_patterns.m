%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [model,res,stats_list] = ...
   fit_coplanar_patterns(solver,x,G,dc,num_planes,varargin)
ransac = make_ransac(solver,x,G,varargin{:});
[model0,res00,stats_list] = ransac.fit(x,dc,G);

[loss,err,cs,loss_info] = ransac.eval.calc_loss(x,model0,dc,G);
res0 = struct('err', err, ...
              'loss', loss, ...
              'cs', cs, ...
              'info', loss_info);
ransac.lo.max_iter = 150;
[loM,lo_res] = ransac.do_lo(x,model0,res0,varargin{:});

keyboard;
stats_list.local_list(end) = struct('model',model, ...
                                    'res',res, ...
                                    'trial_count',stats_list.local_list(end).trial_count, ...
                                    'model_count',stats_list.local_list(end).model_count);