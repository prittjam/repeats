classdef GrEval < handle
    properties    
        sigma = 1;
        iff = [];
        motion_model = @HG.laf2xN_to_RtxN;
        T = [];
    end
    
    methods(Static)        
        function E = calc_error_impl(u,v,invH,motion_model,cutoff)
            [rt,ii,jj] = HG.laf2xNxN_to_RtxNxN(v,'motion_model',motion_model);
            invrt = Rt.invert(rt);

            ut1 = LAF.renormI(blkdiag(invH,invH,invH)* ...
                              LAF.apply_rigid_xforms(v(:,ii),rt));
            ut2 = LAF.renormI(blkdiag(invH,invH,invH)* ...
                              LAF.apply_rigid_xforms(v(:,jj),invrt));

            d2 = sum([ut1-u(:,jj); ...
                      ut2-u(:,ii)].^2);

            E = d2 > cutoff;
        end         
    end
    
    methods
        function this = GrEval(varargin)
            [this,~] = cmp_argparse(this,varargin{:});
            this.iff = @(x) make_iif(sum(x < this.T) > 1, ...
                                     @() x < this.T, ...
                                     true, ...
                                     @() false(1,numel(x)));
            this.T = 10.026*this.sigma^2;
        end        
        
        function [loss,E] = calc_loss(this,dr,G,H)         
            invH = inv(H);
            
            u = [dr(:).u];
            v = LAF.renormI(blkdiag(H,H,H)*u);

            E = ...
                cmp_splitapply(@(uu,vv) { GrEval.calc_error_impl(uu,vv, ...
                                                              invH,this.motion_model,this.T) }, ...
                               u,v,findgroups(G)); 

            E = [E{:}];
            E(isnan(E)) = 1;
            loss = sum(E);
        end        
        
        function cs = calc_cs(this,E)
            cs = 1-E;
        end                        
    end
end
