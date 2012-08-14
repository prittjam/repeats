function varargout = scene_get_dr_subtypes(cfg)
if isfield(cfg,'subtype')
    subtypes = cfg.subtype.tbl;
else
    subtypes = {};
end