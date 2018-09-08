%
%  Copyright (c) 2018 James Pritts, Denys Rozumnyi
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts and Denys Rozumnyi
%
classdef Seeds < Gen
    methods(Access=public)
        function this = Seeds()
        end
    end
    
    methods(Static)
        function segments = make(img,cfg)
            segments0 = uint32(mexSEEDS(img.data,cfg.num_spixels) + 1);
        	segments = SPIXEL.renumber(segments0);
        end          
    end
end