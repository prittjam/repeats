classdef mserm_cfg < DR.mser_cfg
    methods 
        function this = mserm_cfg(varargin)
            this@DR.mser_cfg(varargin{:});
            this.name = this.set_name(this);
        end
    end
end