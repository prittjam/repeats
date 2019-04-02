%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%

img_path = 'data/cropped_dartboard.jpg';

dt = datestr(now,'yyyymmdd_HHMMSS');

repeats_init();

solver = WRAP.lafmn_to_qAl(WRAP.laf222_to_ql);

results_path = fullfile('results',class(solver.solver_impl),dt);

ransac_settings = ...
    { 'min_trial_count', 750, ...
      'max_trial_count', 750, ...
      'reprojT', 7 } ;

dr_settings = ...
    { 'desc_cutoff', 150 }; 

