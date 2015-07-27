function [cfghash json] = cfg2hash(cfg, name)
    error(nargchk(1, 2, nargin));
    if (nargin < 2)
    	name = '';
    end

    cfg = orderfields(cfg);
    
    %is cfg ordered?
    if (~all(strcmp(fieldnames(cfg), fieldnames(orderfields(cfg)))))
        warning('You are creating hash from unordered struct!');
    end

    json = KEY.mat2json(cfg);
    json = [name json];
    cfghash = KEY.hash(json, 'md5');