function is_degen = eg_sample_degen(u,sample_set,varargin)
is_degen = pt_corr_is_injective(u, sample_set, varargin{ : });