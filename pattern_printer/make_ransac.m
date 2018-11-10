%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function ransac = make_ransac(solver,x,Gsamp,Gapp,cc,varargin)
sampler = RepeatSampler(x,solver.mss,Gsamp);
eval = NewRepeatEval(varargin{:});
lo = RepeatLo('Rt',eval,varargin{:});
ransac = Ransac(solver,sampler,eval,'lo',lo);