function key = make_key(cfg)
    if isempty(cfg)
        key = repmat('0',1,32);
    elseif  ischar(cfg)
        key = cfg;
    else
        scfg = DR.make_struct(cfg);
        key = cfg2hash(scfg,true);
    end
end