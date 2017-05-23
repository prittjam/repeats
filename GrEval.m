classdef GrEval < handle
    properties    
        sigma = 1;
        iff = [];
        motion_model = [];
        motion_solver = @HG.laf2xN_to_RtxN;
        T = [];
    end
    
    methods(Static)        
        function E = calc_error_impl(u,v,invH,motion_solver,cutoff)
            N = size(u,2);

            [ii,jj] = itril([N N],-1);
            rt = feval(motion_solver,[v(:,ii);v(:,jj)]);            
            
            [rt,is_inverted] = unique_ro(rt);
                
            [jj(is_inverted),ii(is_inverted)] = deal(ii(is_inverted), ...
                                                     jj(is_inverted));
            
            invrt = Rt.invert(rt);
            ut1 = LAF.renormI(blkdiag(invH,invH,invH)* ...
                              LAF.apply_rigid_xforms(v(:,ii),rt));
            ut2 = LAF.renormI(blkdiag(invH,invH,invH)* ...
                              LAF.apply_rigid_xforms(v(:,jj),invrt));

            Y = sum([ut1-u(:,jj); ...
                     ut2-u(:,ii)].^2);

            Z = linkage(Y,'complete');
            G = cluster(Z,'cutoff',cutoff,'criterion','distance');

            freq = hist(G,1:max(G));            
            
            [max_freq,maxG] = max(freq);

            E = ones(1,size(u,2));
            if max_freq > 1
                E(find(G == maxG)) = 0;
            end
        end 
    end
    
    methods
        function this = GrEval(varargin)
            [this,~] = cmp_argparse(this,varargin{:});
            this.iff = @(x) make_iif(sum(x < this.T) > 1, ...
                                     @() x < this.T, ...
                                     true, ...
                                     @() false(1,numel(x)));
            this.T = 20*this.sigma^2;
            
            switch this.motion_model
              case 't'
                this.motion_solver = @HG.laf2xN_to_txN;
              case 'Rt'
                this.motion_solver = @HG.laf2xN_to_RtxN;
            end
        end        
        
        function [loss,E] = calc_loss(this,dr,G,H)         
            invH = inv(H);
            
            u = [dr(:).u];
            v = LAF.renormI(blkdiag(H,H,H)*u);
            
            E = zeros(1,numel(G));
            
            uG = unique(G(~isnan(G)));
            
            for g = uG
                ind = find(G == g);
                E(ind) = GrEval.calc_error_impl(u(:,ind),v(:,ind), ...
                                                invH,this.motion_solver,this.T);
            end
            
            %            E = ...
            %                msplitapply(@(uu,vv) ...
            %                            GrEval.calc_error_impl(uu,vv, ...
            %                                                   invH,this.motion_model,this.T) , ...
            %                            u,v,findgroups(G)); 

            E(isnan(E)) = 1;
            loss = sum(E);
        end        
        
        function cs = calc_cs(this,E)
            cs = 1-E;
        end                        
    end
end
