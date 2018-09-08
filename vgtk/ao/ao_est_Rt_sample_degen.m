%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function is_degen = ao_est_Rt_sample_degen(u,sample_set,t)
    min_sample_size = 3;
    N  = sum(sample_set);
    upper = find(triu(ones(N,N),1));
    D1 = pt_sq_dist(u(1:3,sample_set), ...
                    u(1:3,sample_set));
    M1 = sum(D1(upper) < t^2);
    num_dups = sum(M1(:)) > 0;

    is_degen = (N-num_dups) < min_sample_size;