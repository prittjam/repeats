% Copyright (c) 2017 James Pritts
% 
classdef laf2x2_to_AHinf
    properties
        mcs = 2;
        mss = 2;
    end
    
    methods
        function this = laf2x2_to_AHinf()
        end
        
        function M = fit(this,dr,corresp,idx)            
            m  = reshape(corresp(:,idx),1,[]);

            x = [dr(m).u];
            G = findgroups([dr(m).Gapp]);

            Hp = HG.laf2x2_to_Hinf(x,G);
            xp = LAF.renormI(blkdiag(Hp,Hp,Hp)*x);
            Ha = HG.laf2x1_to_Amu(xp,G);
            
            if ~isempty(Ha)
                M.H = Ha*Hp ;
            else
                M.H = Hp;
            end
        end

        function is_good = is_sample_good(this,dr,corresp,idx)
            m  = reshape(corresp(:,idx),1,[]);
            x = [dr(m).u];
            is_good = not(LAF.are_colinear(x));
        end    

        function is_good = is_model_good(this,dr,corresp,idx,M) 
            m  = reshape(corresp(:,idx),1,[]);
            x = [dr(m).u]; 
            is_good = LAF.are_same_orientation(x,M.H(3,:)'); 
        end        
        
        function M = fix(this,dr,corresp,idx,model)
            M = [];
        end
    end
end 
