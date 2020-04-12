%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function T = make_rd_div_tform(cc,q,varargin)
    if isnumeric(q)
        display('CAM.make_rd_div_tform(cc,q) is deprecated. New call format: CAM.make_rd_div_tform(q,Name,Value)');
        T = maketform('custom',2,2, ...
                    @CAM.rd_div_tform, ...
                    @CAM.ru_div_tform, ...
                    struct('cc',cc,'q',q));
    else
        varargin = {q, varargin{:}};
        q = cc;
        T = maketform('custom',2,2, ...
                    @CAM.rd_div_tform, ...
                    @CAM.ru_div_tform, ...
                    struct('q',q,varargin{:}));
    end
