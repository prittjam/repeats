function [] = scene_add_sift_normalization(detectors, ...
                                           sift_normalize)
for i = 1:numel(detectors)
    detectors.sift_normalize = sift_normalize;
end