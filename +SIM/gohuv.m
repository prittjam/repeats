% Copyright (c) 2017 James Pritts
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
function [] = gohuv()
addpath('..');
gmr_init();

app_thresh = 0.2;

propose_params =  { ...
    'app_thresh', app_thresh, ... 
    'app_knn', 5, ...
    'app_cutoff', 0.4, ...
    'merge_app_clusters', true, ...    
    'num_linfs', 1000, ...
    'cluster_linfs', true ...
                  };

[dr,img,spixels,gtlabels,gtctg] = SIM.make_dr('outlier_pct',0, ...
                                              'ccd_sigma',0, ...
                                              'desc_xform','DR.sift_calc_rootSIFT', ...
                                              'sift_sigma',0.0);

propose = Propose(img,propose_params{:});
propose.set_dr(dr);
[dr_groups,dr] = propose.make_app_clusters();
[HH0,HH00,estind] = propose.make_linfs(dr_groups);

HG.linf_laf1_to_Huv.estimate([dr.u(:,1);dr.u(:,6)], ...
                             1,1,HH0{1}(3,:)');