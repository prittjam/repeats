classdef Sift < CfgBase
    properties(Access=private,Constant)
        uname = 'Sift';
    end


    properties(Access=public)
        ignore_gradient_sign = 0;
        desc_factor = 3*sqrt(3);
        verbose = 1;
        patch_size = 41;
        compute_descriptor = 1;
        output_format= 2;
    end

    methods(Static)
        function this = Sift(varargin)
            this = this@CfgBase(varargin{:});
            if ~isempty(varargin)
                this = helpers.vl_argparse(this,varargin{:});
            end
        end

        function uname = get_uname(this)
            uname = SIFT.CFG.Sift.uname;
        end
    end
end