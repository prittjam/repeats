classdef Img < handle
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
        function this = Img(varargin)
            cfg = struct('data',[],'url',[],'cid',[]);
            cfg = helpers.vl_argparse(cfg,varargin{:});
            this.data = cfg.data;
            this.cid = cfg.cid;
           
            if ~isempty(cfg.url)
                this.url = fullfile(cfg.url);
            end

            if isempty(this.data) && ~isempty(this.url)
                this.data = imread(this.url);
                filecontents = get_raw_img(this.url);
                this.cid = HASH.hash(filecontents,'MD5');
            end

            this.height = size(this.data,1);
            this.width = size(this.data,2);
            this.area = this.width*this.height;

            if (ndims(this.data) == 3)
                this.intensity = rgb2gray(this.data);
            elseif (ndims(this.data) == 1)
                this.intensity = data;
            end
        end
    end
    
end