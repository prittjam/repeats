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
        function this = img(data)
            this.url = '';
            this.description = '';

            if ~isempty(data) && usejava('jvm')
                this.id = HASH.img(data);
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
        end 
    end

end