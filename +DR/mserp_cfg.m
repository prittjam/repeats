classdef mserp_cfg < DR.mser_cfg
    methods 
        function this = mserp_cfg(varargin)
            this@DR.mser_cfg(varargin{:});
            name = this.set_name(this);
            this.name = name;
        end
    end
end