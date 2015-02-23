function key = make_key(cfg)
    key = repmat('0',1,32);

    if  ischar(cfg)
        key = cfg;
    else
        scfg = DR.make_struct(cfg);
        if usejava('jvm')
            key = cfg2hash(scfg,true);
        end
    end
end