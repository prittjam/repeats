%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [model,res,stats_list] = ...
   fit_coplanar_patterns(solver,x,Gsamp,Gapp,cc,num_planes,varargin)
ransac = make_ransac(solver,x,Gsamp,Gapp,cc,varargin);
[model0,res0,stats_list] = ransac.fit(x,cc,Gsamp,Gapp);
ransac.lo.max_iter = 150;
[loss0,E] = ransac.eval.calc_loss(x,model0,Gsamp,Gapp,cc,num_planes,varargin);
model = model0;
res = res0;