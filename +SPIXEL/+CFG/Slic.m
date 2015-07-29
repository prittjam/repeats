classdef Slic < CfgBase
    properties(Access=private,Constant)
        uname = 'Slic';
    end
    
    properties(Access = public)
        region_size = 50 
        regularizer = 0.1
    end
    
    methods
        function this = Slic(varargin)
            this = this@CfgBase(varargin{:});
            if ~isempty(varargin)
                if numel(varargin) > 1
                    [this,~] = helpers.vl_argparse(this,varargin{:});
                elseif isa(varargin{1},'SPIXEL.CFG.Slic')
                    this = copy(varargin{1});
                end
            end
        end
    end
    
    methods(Static)
        function uname = get_uname()
            uname = SPIXEL.CFG.Slic.uname;
        end
    end
end 