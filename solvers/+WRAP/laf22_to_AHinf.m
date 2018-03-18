% Copyright (c) 2017 James Pritts
% 
classdef laf22_to_AHinf < WRAP.LafRectSolver
    properties 
        cc = [];
    end
    
    methods
        function this = laf22_to_AHinf(cc)
            this = this@WRAP.LafRectSolver(2); 
            this.cc = cc;
        end
        
        function M = fit(this,x,corresp,idx,varargin)            
            Gsamp = varargin{1};
            Gapp = varargin{2};
            
            m  = unique(reshape(corresp(:,idx),1,[]));
            H = HG.laf2x2_to_Hinf(x(:,m),findgroups(Gsamp(m))); 
            xp = LAF.renormI(blkdiag(H,H,H)*x);
            A = HG.laf1x2_to_Amu(xp(:,m),findgroups(Gapp(m)));
            if ~isempty(A)
                M = struct('A', A, ...
                           'l',transpose(H(3,:)), ...
                           'cc', this.cc, ...
                           'q', 0);
            else
                M = [];
            end
        end
    end
end 
