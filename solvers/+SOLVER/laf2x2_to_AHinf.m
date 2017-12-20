% Copyright (c) 2017 James Pritts
% 
classdef laf2x2_to_AHinf
    methods
        function this = laf2x2_to_AHinf()
        end
        
        function M = fit(this,x,corresp,idx,varargin)            
            Gsamp = varargin{1};
            Gapp = varargin{2};
            
            m  = unique(reshape(corresp(:,idx),1,[]));
            x = [dr(m).u];
            Hinf = HG.laf2x2_to_Hinf(x,findgroups(Gsamp(m)));
            xp = LAF.renormI(blkdiag(Hp,Hp,Hp)*x);
            A = HG.laf1x2_to_Amu(xp,findgroups(Gapp(m)));
            M = struct('A',A, ...
                       'Hinf',Hinf);
        end

        function is_good = is_sample_good(this,dr,corresp,varargin)
            m  = unique(reshape(corresp(:,idx),1,[]));
            x = [dr(m).u];
            is_good = not(LAF.are_colinear(x));
        end    

        function is_good = is_model_good(this,dr,corresp,idx,M) 
            m  = unique(reshape(corresp(:,idx),1,[]));
            x = [dr(m).u]; 
            is_good = LAF.are_same_orientation(x,M.l); 
        end        
        
        function M = fix(this,dr,corresp,idx,model)
            M = [];
        end
    end
end 
