classdef Lo < handle
    properties    
    end

    methods
        function this = Lo()
            
        end
        
        function M = fit(this,dr,G)
            u = [dr(G>0).u];
            G = findgroups(G(G > 0));
            H = HG.laf2x2_to_Hinf(u,G);            
            v = LAF.renormI(blkdiag(H,H,H)*u);
            X = cmp_splitapply(@(x) ({x}),v,G);    
            A = HG.laf2x1_to_Amu(X);
            if isempty(A)
                M = { H };
            else
                M = { A*H };
            end
        end
    end
end