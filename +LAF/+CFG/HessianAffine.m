classdef HessianAffine < LAF.CFG.AffPt
    properties
        detector = 7;
    end

    methods 
        function this = HessianAffine(varargin)
            this@LAF.CFG.AffPt(varargin{:});
        end
    end
end