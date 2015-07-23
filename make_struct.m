function scfg = make_struct(cfg)
    warning('off','MATLAB:structOnObject');
    scfg = struct(cfg);
    if isa(cfg,'dr.dr_cfg')
        p = properties(dr.dr_cfg([]));
            scfg = rmfield(scfg,p);
    end
    warning('on','MATLAB:structOnObject');
end