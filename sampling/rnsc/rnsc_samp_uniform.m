function s = rnsc_samp_uniform(u,k,varargin)
N = size(u,2);
ind = randsample([1:N],k);
s = false(1,N);
s(ind) = true;