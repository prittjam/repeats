%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function is_degen = pt_corr_is_injective(u, sample, varargin)
    t = varargin{ 1 };

    N  = sum(sample);

    upper = find(triu(ones(N,N),1));
    D1 = pt_sq_dist(u(1:3,sample), ...
                    u(1:3,sample));
    D2 = pt_sq_dist(u(4:6,sample), ...
                    u(4:6,sample));
    
    M1 = sum(D1(upper) < t^2);
    M2 = sum(D2(upper) < t^2);

    is_degen = sum(M1(:)+M2(:)) > 0;