classdef GrLo < handle
    properties    
    end

    methods
        function this = GrLo()
            
        end
        
        function M = fit(this,dr,labeling,res)
            G0 = res.cs.*labeling;
            u = [dr(G0>0).u];
            G = findgroups(G0(G0 > 0));

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

