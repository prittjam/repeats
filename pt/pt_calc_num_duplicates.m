function num_duplicates = pt_calc_num_duplicates(u, sample, varargin)
tsq = varargin{ 1 };

N = sum(sample);

upper = find(triu(ones(N,N),1));
D1 = pt_sq_dist(u(1:3,sample), ...
                u(1:3,sample));
D2 = pt_sq_dist(u(4:6,sample), ...
                u(4:6,sample));

M1 = sum(D1(upper) < tsq);
M2 = sum(D2(upper) < tsq);

num_duplicates = sum(M1(:)+M2(:)) > 0;