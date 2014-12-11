classdef noop < DR.CFG.dr
    methods 
        function this = noop(dr,varargin)
            this = this@DR.CFG.dr(dr,varargin{:});
            if ~isempty(varargin)
                this = helpers.vl_argparse(this,varargin{:});
            end
            this.name = this.set_name(this);
        end
    end
end