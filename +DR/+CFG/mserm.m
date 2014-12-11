classdef mserm < DR.CFG.mser
    methods 
        function this = mserm(varargin)
            this@DR.CFG.mser(varargin{:});
            this.name = this.set_name(this);
        end
    end
end