%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [model_list,lo_res_list,stats_list,cspond] = ...
   fit_coplanar_patterns(solver,x,Gsamp,Gapp,cc,num_planes,varargin)
[ransac,cspond] = make_ransac(solver,x,Gsamp,Gapp,cc,varargin);
[model0,res0,stats_list] = ...
        ransac.fit(x,cspond,cc,Gsamp,Gapp);
ransac.lo.max_iter = 150;
[model_list,lo_res_list] = ...
    ransac.lo.fit(x,cspond,model0,res0,Gsamp,Gapp);