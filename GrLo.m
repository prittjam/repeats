classdef GrLo < handle
    properties    
        iijj = [];
    end

    methods(Static)        
        function IJ = itril_wrap(g)
            N = numel(g);
            [ii,jj] = itril([N N],-1);
            IJ = [g(ii);g(jj)];
       end
    end
    
    methods
        function this = GrLo(labeling)
            IJ = cmp_splitapply(@(g) { GrLo.itril_wrap(g) }, ...
                                1:numel(labeling),labeling);
            this.iijj = [ IJ{:} ] ;
        end
        
        function M = fit(this,dr,labeling,res)
            inl = all(bsxfun(@times,res.cs,this.iijj));
            inl_labels = unique(reshape(this.iijj(:,inl),1,[]));
            G = findgroups(labeling(inl_labels));
            u = [dr(inl_labels).u];
            
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

