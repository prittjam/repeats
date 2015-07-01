classdef hessian_affine < AFFPTS.CFG.affpts
    properties
        detector = 7;
    end

    methods 
        function this = hessian_affine(varargin)
            this@AFFPTS.CFG.affpts(varargin{:});
        end
    end
end