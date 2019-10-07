%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function ransac = make_ransac(solver,x,G,varargin)
cspond = splitapply(@(ind) { make_cspond(ind) },1:size(G,2),G);
cspond = [cspond{:}];

sampler = RepeatSampler(x,solver.mss,G,cspond,varargin{:});
eval = RepeatEval(cspond,varargin{:});
lo = RepeatLo(eval,varargin{:});
ransac = Ransac(solver,sampler,eval,'lo',lo);


function cspond = make_cspond(ind)
N = size(ind,2);
[ii0,jj0] = itril([N N],-1);
cspond = [ind(ii0);ind(jj0)];