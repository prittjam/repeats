function dr = dr_get_stereo_set(dr_defs,stereo_set,detectors)
k = 1;
dr = cell(2,numel(stereo_set));
for pair = stereo_set
    dr(1:2,k) = dr_get_stereo_pair(dr_defs,pair,detectors);
    k = k+1;              
end