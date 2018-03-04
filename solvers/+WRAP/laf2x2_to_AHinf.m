% Copyright (c) 2017 James Pritts
% 
classdef laf2x2_to_AHinf < WRAP.LafRectSolver
    methods
        function this = laf2x2_to_AHinf()
            this = this@WRAP.LafRectSolver(2); 
        end
        
        function M = fit(this,x,corresp,idx,varargin)            
            Gsamp = varargin{1};
            Gapp = varargin{2};
            
            m  = unique(reshape(corresp(:,idx),1,[]));
            H = HG.laf2x2_to_Hinf(x(:,m),findgroups(Gsamp(m)));
            xp = LAF.renormI(blkdiag(H,H,H)*x);
            A = HG.laf1x2_to_Amu(xp(:,m),findgroups(Gapp(m)));
            if ~isempty(A)
                M = struct('H',A*H, ...
                           'l',transpose(H(3,:)));
            else
                M = [];
            end
        end
    end
end 
