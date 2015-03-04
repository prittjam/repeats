function [cfghash json] = cfg2hash(cfg, autoorder)
    error(nargchk(1, 2, nargin));
    if (nargin == 1)
        autoorder = false;
    end

    if (autoorder)
        cfg = orderfields(cfg);
    end

    %is cfg ordered?
    if (~all(strcmp(fieldnames(cfg), fieldnames(orderfields(cfg)))))
        warning('You are creating hash from unordered struct!');
    end

    json = mat2json(cfg);
    cfghash = HASH.hash(json, 'md5');