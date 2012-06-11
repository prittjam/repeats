function dst_cfg = scene_edit_cfg_fields(src_cfg,dst_cfg)
fn = fieldnames(detector_tmp);
for m = 1:numel(fn)
    nm = fn{m};
    dst_cfg.(nm) = src_cfg.(nm);
end 