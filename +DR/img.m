classdef img < handle
    properties
        id;
        data;
        height; 
        width;
        area;
        url;
        intensity;
        description;
    end

    methods(Access=public)
        function this = img(data,varargin)
            this.url = '';
            this.description = '';

            if ~isempty(data)
                this.id = cvdb_hash_img(data);
            end

            this.data = data;
            this.height = size(data,1);
            this.width = size(data,2);

            if (ndims(this.data) == 3)
                this.intensity = rgb2gray(data);
            else
                this.intensity = data;
            end
            this.area = this.width*this.height;
            
            [this,leftover] = ...
                helpers.vl_argparse(this,varargin{:});
        end 
    end
end