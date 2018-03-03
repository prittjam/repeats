function is_degen = plane_sample_degen(u,sample_set,t, ...
                                       min_sample_size)
N  = sum(sample_set);
upper = find(triu(ones(N,N),1));
D1 = pt_sq_dist(u(1:3,sample_set), ...
                u(1:3,sample_set));
M1 = sum(D1(upper) < t^2);
num_dups = sum(M1(:)) > 0;
is_degen = (N-num_dups) < min_sample_size;