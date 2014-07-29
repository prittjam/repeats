classdef mserm_cfg < dr.mser_cfg
    methods 
        function this = mserm_cfg(varargin)
            this@dr.mser_cfg(varargin{:});
            this.name = this.set_name(this);
        end
    end
end