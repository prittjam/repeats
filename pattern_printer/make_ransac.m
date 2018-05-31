function [ransac,corresp] = make_ransac(solver,x,Gsamp,Gapp,cc,varargin)
corresp = ...
    cmp_splitapply(@(u) { VChooseK(u,2)' }, 1:numel(Gsamp),Gsamp);
corresp = [ corresp{:} ];
sampler = RepeatSampler(x,corresp,solver.mss,Gsamp);
eval = RepeatEval();

lo = RepeatLo(cc,'Rt','vqT',15,'reprojT',15);
ransac = Ransac(solver,sampler,eval,'lo',lo);
