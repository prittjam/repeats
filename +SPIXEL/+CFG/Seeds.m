classdef Seeds < CfgBase
    properties(Access=private,Constant)
        uname = 'SEEDS';
    end
    
    properties(Access = public)
        num_spixels = 150
        min_size = 0
    end

    methods
        function this = Seeds(varargin)
            this = this@CfgBase(varargin{:});
            if ~isempty(varargin)
                if numel(varargin) > 1
                    [this,~] = cmp_argparse(this,varargin{:});
                elseif isa(varargin{1},'SPIXEL.CFG.Seeds')
                    this = copy(varargin{1});
                end
            end
        end
    end
    
    methods(Static)
        function uname = get_uname()
            uname = SPIXEL.CFG.Seeds.uname;
        end
    end
end 