classdef GrLo < handle
    properties
        motion_model = @HG.laf2xN_to_RtxN;
    end
    
    methods
        function this = GrLo(labeling,varargin)
            [this,~] = cmp_argparse(this,varargin{:});
        end
        
        function M = fit(this,dr,labeling,res)
            G = labeling.*res.cs;
            
            u = [dr(G>0).u];
            Gr = logical([dr(G>0).reflected]);
            G = findgroups(G(G>0));
            
            Hp = HG.laf2x2_to_Hinf(u,G);            
            v = LAF.renormI(blkdiag(Hp,Hp,Hp)*u);

            switch this.motion_model
              case 'HG.laf2xN_to_RtxN'
                Ha = HG.laf2x1_to_Amu(v,G);
              case 'HG.laf2xN_to_txN'
                Ha = HG.laf2x1_to_Amur(v,G,Gr);
            end

            if isempty(Ha)
                M = { Hp };
            else
                M = { Ha*Hp };
            end
        end

    end
end

