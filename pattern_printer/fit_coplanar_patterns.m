%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [model,res,stats_list] = ...
   fit_coplanar_patterns(solver,x,G,cc,num_planes,varargin)
ransac = make_ransac(solver,x,G,cc,varargin);
[model0,res0,stats_list] = ransac.fit(x,cc,G);
ransac.lo.max_iter = 150;
[model,res] =  ransac.lo.fit(x,model0,res0,cc,G);

stats_list.lo(end) = struct('model',model, ...
                            'res',res, ...
                            'trial_count',stats_list.lo(end).trial_count, ...
                            'model_count',stats_list.lo(end).model_count);
