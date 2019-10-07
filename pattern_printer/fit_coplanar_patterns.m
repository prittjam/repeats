%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [M,res,stats_list] = fit_coplanar_patterns(solver,x,G,dc,num_planes,varargin)
ransac = make_ransac(solver,x,G,varargin{:});
[M0,res0,stats_list] = ransac.fit(x,dc,G);
[M,res] = guided_search(x,M0,ransac,dc,G);

if res.loss < res0.loss
    display('Guided search suceeded.')
    stats_list = cat(2,stats_list.local_list, struct('model',M, ...
                                                     'res',res, ...
                                                     'trial_count',stats_list.local_list(end).trial_count, ...
                                                     'model_count', ...
                                                     stats_list.local_list(end).model_count));
else
    display('Guided search failed.')
    M = M0; 
    res = res0; 
end
    
% Note that guided search may not always decrease loss because
% the parsimonious model selection can be randomized. 
function [M,res] = guided_search(x,M0,ransac,dc,G)
    [loss,err,cs,loss_info] = ransac.eval.calc_loss(x,M0,dc,G);
    res0 = struct('err', err, ...
                  'loss', loss, ...
                  'cs', cs, ...
                  'info', loss_info);
    ransac.lo.max_iter = 150;
    [M,res] = ransac.do_lo(x,M0,res0,dc,G);