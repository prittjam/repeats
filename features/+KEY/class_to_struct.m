%
%  Copyright (c) 2018 James Pritts, Denys Rozumnyi
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts and Denys Rozumnyi
%
function scfg = make_struct(cfg)
    warning('off','MATLAB:structOnObject');
    scfg = struct(cfg);
    warning('on','MATLAB:structOnObject');
