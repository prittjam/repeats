classdef VlSlic < Gen
    methods(Access=public)
        function this = VlSlic()
        end
    end
    
    methods(Static)
        function segments = make(img,cfg)
            imlab = single(im2double(img.data));
            segments0 = vl_slic(imlab,cfg.region_size, ...
                                cfg.regularizer);
            segments = SPIXEL.relabel(segments0);
        end          
    end
end