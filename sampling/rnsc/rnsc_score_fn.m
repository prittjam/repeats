function [cost, inlying_set] = rnsc_score_fn(d, t)
    inlying_set = d < t^2;
    cost = sum(inlying_set);