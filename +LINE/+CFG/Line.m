classdef Line < CfgBase 
    properties(Access=private,Constant)
        uname = 'Line';
    end

    properties(Access = public)
        
    end

    methods
        function this = Line(varargin)
            this = this@CfgBase(varargin{:});
            if ~isempty(varargin)
                this = cmp_argparse(this,varargin{:});
            end
        end

        function uname = get_uname(this)
            uname = LINE.CFG.Line.uname;
        end
    end
end 