function ransac = make_ransac(x,corresp,solve,varargin)
Gsamp = varargin{1};
sampler = RepeatSampler(x,corresp,solver.mss,Gsamp);
eval = RepeatEval();
lo = RepeatLo(cc,'t','vqT',10);
ransac = Ransac(solver,sampler,eval,'lo',lo);
