function [F_best, inl, n_points_stats] = faff_gs(u, v, t, max_trials)

num_inliers = size(u,2);
trial = 0;
n_points_stats.num_input_inliers = num_inliers;

M = faff_n_points(u);
[inl, F_best] = faff_gs_distfn(M, v, t);

while (num_inliers ~=length(inl))
    num_inliers = length(inl);
    M = faff_n_points(v(:,inl));
    [inl, F_best] = faff_gs_distfn(M, v, t);
    trial = trial+1;
end

n_points_stats.num_trials = trial;
n_points_stats.num_output_inliers = length(inl);
n_points_stats.t = t;
n_points_stats.max_num_samples = max_trials;
n_points_stats.num_data = length(u);
