classdef HessianAffine < COVDET.CFG.AffPt
    properties
        detector = 7;
    end

    methods 
        function this = HessianAffine(varargin)
            this@COVDET.CFG.AffPt(varargin{:});
        end

        function uname = get_uname(this)
        	uname = 'HessianAffine';
        end
    end
end