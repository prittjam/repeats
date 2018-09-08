%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [s,sampling_seed] = rnsc_samp_uniform(u,k,sampling_seed)

rng(sampling_seed);
sampling_seed = randi(intmax('int32'),1);

N = size(u,2);
ind = randsample(N,k);
s = false(1,N);
s(ind) = true;