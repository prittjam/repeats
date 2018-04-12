classdef Slic < CfgBase
    properties(Access=private,Constant)
        uname = 'Slic';
    end
    
    properties(Access = public)
        region_size = 50 
        regularizer = 0.1
        num_spixels = 150
    end

    methods
        function this = Slic(varargin)
            this = this@CfgBase(varargin{:});
            if ~isempty(varargin)
                if numel(varargin) > 1
                    [this,~] = cmp_argparse(this,varargin{:});
                elseif isa(varargin{1},'SPIXEL.CFG.Slic')
                    this = copy(varargin{1});
                end
            end
            if numel(this.region_size) == 2
                this.region_size = max(10,min(80, sqrt(1.3*max(this.region_size)) ));
            end
        end
    end
    
    methods(Static)
        function uname = get_uname()
            uname = SPIXEL.CFG.Slic.uname;
        end
    end
end 