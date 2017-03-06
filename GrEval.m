classdef GrEval < handle
    properties    
        sigma = 1;
        iff = [];
        motion_model = @HG.laf2xN_to_RtxN;
        T = [];
    end
    
    methods(Static)
        function E = calc_error_impl(u,H,motion_model,cutoff)
            v = LAF.renormI(blkdiag(H,H,H)*u);
            [rt,ii,jj,is_reflected] = HG.laf2xNxN_to_RtxNxN(v,'motion_model', ...
                                                             motion_model);
            invrt = Rt.invert(rt);
            N = size(v,2);
            M = size(rt,2);
            invH = inv(H);

            ut1 = LAF.renormI(blkdiag(invH,invH,invH)* ...
                              LAF.apply_rigid_xforms(v(:,ii),rt));
            dut1 = ut1-u(:,jj);
       
            ut2 = LAF.renormI(blkdiag(invH,invH,invH)* ...
                              LAF.apply_rigid_xforms(v(:,jj),invrt));
            dut2 = ut2-u(:,ii);
            
            d2 = sum([dut1;dut2].^2);
            Z = linkage(d2,'complete');
            T = cluster(Z,'cutoff', cutoff, 'criterion','distance');
            freq = hist(T,1:max(T));
            [max_freq,maxc] = max(freq);
            E = ones(1,N);
            if max_freq > 3
                E(find(T==maxc)) = 0;
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
            this.T = 21.026*this.sigma^2;
        end        
        
        function [loss,E] = calc_loss(this,dr,G,H)
            u = [dr(:).u];
            E = msplitapply(@(u) GrEval.calc_error_impl(u,H,this.motion_model,this.T), ...
                            u,findgroups(G)); 
            E(isnan(E)) = 1;
            loss = sum(E);
        end        
        
        function cs = calc_cs(this,E)
            cs = 1-E;
        end                        
    end
end

%        function d2 = calc_loss_impl(u,H,motion_model,linkage_method,dist_cutoff)
%            v = LAF.renormI(blkdiag(H,H,H)*u);
%            [Rt,ii,jj,is_reflected] = ...
%                HG.laf2xNxN_to_RtxNxN(v,'motion_model',motion_model, ...
%                                      'do_reflection', false);
%            N = size(v,2);
%            M = numel(Rt);
%            err = zeros(1,M);
%            invH = inv(H);
%            ut = LAF.renormI(blkdiag(invH,invH,invH)* ...
%                             LAF.apply_rigid_xforms(v(:,ii),[Rt(:).theta],[Rt(:).t]));
%            du = reshape(ut-u(:,jj),3,[]);
%            d = max(reshape(sqrt(sum(du.^2)),3,[]));
%        end 
