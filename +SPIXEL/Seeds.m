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