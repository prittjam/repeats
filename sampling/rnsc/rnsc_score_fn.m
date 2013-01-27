function [utility, inlying_set] = rnsc_score_fn(d, t)
    inlying_set = d < t^2;
    utility = sum(inlying_set);