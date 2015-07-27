function key = make(cfg)
    key = repmat('0',1,32);
    if isempty(cfg)
    	return;
    end
    if  ischar(cfg)
        key = cfg;
    else
        scfg = KEY.class_to_struct(cfg);
        if usejava('jvm')
            key = KEY.cfg2hash(scfg, class(cfg));
        end
    end
end