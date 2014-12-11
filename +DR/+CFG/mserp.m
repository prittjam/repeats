classdef mserp < DR.CFG.mser
    methods 
        function this = mserp(varargin)
            this@DR.CFG.mser(varargin{:});
            name = this.set_name(this);
            this.name = name;
        end
    end
end