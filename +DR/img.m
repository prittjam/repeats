classdef img < handle
    properties
        data;
        height; 
        width;
        area;
        intensity;
        cid;
    end

    methods(Access=public)
        function this = img(data,cid)
            this.cid = cid;
            this.data = data;
            this.height = size(data,1);
            this.width = size(data,2);

            if (ndims(this.data) == 3)
                this.intensity = rgb2gray(data);
            else
                this.intensity = data;
            end
            this.area = this.width*this.height;
        end
    end
    
end