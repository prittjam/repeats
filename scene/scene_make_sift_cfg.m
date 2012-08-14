function sift_cfg = scene_make_sift_cfg(normalize)
if isempty(normalize)
    sift_cfg.normalize = @(x) x;
else
    sift_cfg.normalize = normalize;
end