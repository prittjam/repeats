%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [timg,trect,T,A] = ru_div_rectify(img,H,cc,q,varargin)
    ru_xform = [];

    if q ~= 0
        ru_xform = CAM.make_ru_div_tform(cc,q);
    end
        
    [timg,trect,T,A] = IMG.rectify(img,H, ...
                                   'ru_xform',ru_xform, ...
                                   varargin{:});