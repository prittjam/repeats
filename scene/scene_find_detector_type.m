function ind = scene_find_detector_type(cdr,name)
ind = find(cellfun(@(x)strcmp(x,name),{cdr(:).name}));