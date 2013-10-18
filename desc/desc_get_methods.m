function method = desc_get_methods(desc_defs,desc)
descids = desc_get_descids(desc_defs,desc);
method = {desc_defs(descids).fnname};
