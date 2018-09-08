%
%  Copyright (c) 2018 James Pritts, Denys Rozumnyi
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts and Denys Rozumnyi
%
classdef VlSlic < Gen
    methods(Access=public)
        function this = VlSlic()
        end
    end
    
    methods(Static)
        function segments = make(img,cfg)
            colorTransform = makecform('srgb2lab');
            imlab = im2single(applycform(img.data, colorTransform));
            segments0 = vl_slic(imlab,cfg.region_size, ...
                                cfg.regularizer);
            segments = SPIXEL.renumber(segments0);
        end          
    end
end