%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [ransac,cspond] = make_ransac(solver,x,Gsamp,Gapp,cc,varargin)
cspond = ...
    cmp_splitapply(@(u) { VChooseK(u,2)' }, 1:numel(Gsamp),Gsamp);
cspond = [ cspond{:} ];
sampler = RepeatSampler(x,solver.mss,Gsamp);
eval = NewRepeatEval();

lo = RepeatLo('Rt','vqT',50,'reprojT',100);
ransac = Ransac(solver,sampler,eval,'lo',lo);
