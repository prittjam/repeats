classdef img < handle
    properties
        data;
        height; 
        width;
        area;
        intensity;
        cid;
        url;
    end

    methods(Access=public)
        function this = img(data,varargin)
            this.data = data;
            this.height = size(data,1);
            this.width = size(data,2);

            if (ndims(this.data) == 3)
                this.intensity = rgb2gray(data);
            else
                this.intensity = data;
            end
            this.area = this.width*this.height;
            
            cfg = struct('url',[],'cid',[]);
            cfg = helpers.vl_argparse(cfg,varargin{:});
            this.url = cfg.url;
            this.cid = cfg.cid;
        end
    end
    
end