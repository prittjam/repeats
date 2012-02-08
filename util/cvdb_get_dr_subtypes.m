function [subtypes,ids,subgenids] = cvdb_get_dr_subtypes(cfg)
if isfield(cfg,'subtype')
    subtypes = cfg.subtype.tbl;
    ids = cfg.subtype.id;
    subgenids = cfg.subgenid;
else
    subtypes = {};
    ids = [];
    subgenids = [];
end