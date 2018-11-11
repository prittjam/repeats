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
[model,res] =  ransac.lo.fit(x,model0,res0,cc,Gsamp,Gapp);

%
%if sum(res0.cs) < sum(res.cs)
%    keyboard;
%    [model,res] =  ransac.lo.fit(x,model0,res0,cc,Gsamp,Gapp);
%end
%
%model = model0;
%res = res0;
%