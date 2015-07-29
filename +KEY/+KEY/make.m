function key = make(cfg)
    key = repmat('0',1,32);
    if isempty(cfg)
    	return;
    end
    if  ischar(cfg)
        key = cfg;
    else
        if ismethod(cfg,'get_uname')
            uname = cfg.get_uname();
        else
            uname = class(cfg);
        end
        if usejava('jvm')
            key = KEY.cfg2hash(scfg,uname);
        end
    end
end