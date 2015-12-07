function key = make(cfg,add)
    if nargin < 2
        add = [];
    end
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
            key = KEY.cfg2hash(cfg,[uname add]);
        end
    end
end