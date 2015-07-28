classdef VlSlic < Gen
    methods
        function this = VlSlic()
        end

        function res = make(this,img,feat_cfg_list,varargin)
        cfg = CFG.Spixel(varargin{:});
        imlab = single(im2double(img.data));
        segments0 = vl_slic(imlab,cfg.region_size, ...
                            cfg.regularizer);
        segments = relabel_slics(segments0);
        end
    end
end




function segments = extract(img,varargin)


