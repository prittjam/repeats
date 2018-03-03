function is_degen = eg_sample_degen(u,sample_set,tsq,min_sample_size)
num_dups = pt_calc_num_duplicates(u,sample_set,tsq);
N = sum(sample_set);

is_degen = (N-num_dups) < min_sample_size;