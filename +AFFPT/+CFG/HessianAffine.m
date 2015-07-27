classdef HessianAffine < AFFPT.CFG.AffPt
    properties
        detector = 7;
    end

    methods 
        function this = HessianAffine(varargin)
            this@AFFPT.CFG.AffPt(varargin{:});
        end
    end
end