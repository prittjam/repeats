classdef Lo < handle
    properties    
    end

    methods
        function this = Lo()
            
        end
        
        function M = fit(this,dr,G)
            u = [dr(G>0).u];
            G = findgroups(G(G > 0));

            Hp = HG.laf2x2_to_Hinf(u,G);            
            v = LAF.renormI(blkdiag(Hp,Hp,Hp)*u);
            Ha = HG.laf2x1_to_Amu(v,G);
            if isempty(Ha)
                M = { Hp };
            else
                M = { Ha*Hp };
            end
        end
    end
end

