classdef HessianAffine < AFFPTS.CFG.Affpts
    properties
        detector = 7;
    end

    methods 
        function this = HessianAffine(varargin)
            this@AFFPTS.CFG.Affpts(varargin{:});
        end
    end
end