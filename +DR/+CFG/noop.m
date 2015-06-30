classdef noop < DR.CFG.dr
    methods 
        function this = noop(varargin)
            this = this@DR.CFG.dr(varargin{:});
            if ~isempty(varargin)
                this = helpers.vl_argparse(this,varargin{:});
            end
        end
    end
end