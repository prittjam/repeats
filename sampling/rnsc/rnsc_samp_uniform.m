function s = rnsc_samp_uniform(u,s,k,varargin)
ind = find(s);
N = numel(ind);
s2 = randsample([1:N],k);
s(ind) = false;
s(ind(s2)) = true;