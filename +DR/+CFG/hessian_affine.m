classdef hessian_affine < DR.CFG.affpts
    properties
        detector = 7;
    end

    methods 
        function this = hessian_affine(varargin)
            this@DR.CFG.affpts(varargin{:});
            name = this.set_name(this);
            this.name = name;
        end
    end
end