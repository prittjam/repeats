classdef GrLo < handle
    properties
        motion_model = [];
        metric_solver = [];
    end
    
    methods(Access = private)
        function Ha = fit_t(this,dr,v,G)
            Gr = logical([dr(:).reflected]);            
            Ha = HG.laf2x1_to_Amur(v,G,Gr);
        end
        
        function Ha = fit_Rt(this,dr,v,G)
            Ha = HG.laf2x1_to_Amu(v,G);
        end        
    end

    methods
        function this = GrLo(labeling,varargin)
            [this,~] = cmp_argparse(this,varargin{:});
            switch this.motion_model
              case 't'
                this.metric_solver = @this.fit_t;
              case 'Rt'
                this.metric_solver = @this.fit_Rt;
            end
        end
        
        function M = fit(this,dr,labeling,res)
            G = labeling.*res.cs;
            ind = find(G > 0);
            
            dr = dr(ind);
            u = [dr(:).u];
            G = findgroups(G(ind));
            Hp = HG.laf2x2_to_Hinf(u,G);            
            v = LAF.renormI(blkdiag(Hp,Hp,Hp)*u);
            
            Ha = feval(this.metric_solver,dr,v,G);

            if isempty(Ha)
                M = { Hp };
            else
                M = { Ha*Hp };
            end
        end

    end
end

