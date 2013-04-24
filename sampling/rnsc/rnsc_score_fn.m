function [utility, inlying_set] = rnsc_score_fn(d, tsq)
    inlying_set = d < tsq;
    utility = sum(inlying_set);