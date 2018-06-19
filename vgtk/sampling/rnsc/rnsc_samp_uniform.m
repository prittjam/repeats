function [s,sampling_seed] = rnsc_samp_uniform(u,k,sampling_seed)

rng(sampling_seed);
sampling_seed = randi(intmax('int32'),1);

N = size(u,2);
ind = randsample(N,k);
s = false(1,N);
s(ind) = true;