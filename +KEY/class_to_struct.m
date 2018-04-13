function scfg = class_to_struct(cfg)
    warning('off','MATLAB:structOnObject');
    scfg = struct(cfg);
    warning('on','MATLAB:structOnObject');