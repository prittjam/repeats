classdef mserp_cfg < dr.mser_cfg
    methods 
        function this = mserp_cfg(varargin)
            this@dr.mser_cfg(varargin{:});
            name = this.set_name(this);
            this.name = name;
        end
    end
end