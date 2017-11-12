function [ransac,corresp] = make_ransac(solver,x,Gsamp,Gapp,cc,varargin)
corresp = cmp_splitapply(@(u) { VChooseK(u,2)' }, ...
                         1:numel(Gsamp),Gsamp);
corresp = [ corresp{:} ];
sampler = RepeatSampler(x,corresp,solver.mss,Gsamp);
%eval = RepeatEval();
%eval = 
if solver.mss == 1
    eval = ElationEval1D(cc);
else
    eval = ElationEval2D(cc);
end

lo = RepeatLo(cc,'t','vqT',15,'reprojT',15);
ransac = Ransac(solver,sampler,eval,'lo',lo);
