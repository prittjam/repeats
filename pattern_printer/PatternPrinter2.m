%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef PatternPrinter2 < handle
    properties    
        x = [];
        
        q0 = [];
        A0 = [];
        l0 = [];
        Rtij0 = [];
        Q = [];
        
        Gm = [];
        cspond = [];
        cc = [];
        
        params = [];
        dz0 = [];
        
        w = [];
        
        num_Rt_params = [];
        motion_model = 'Rt';
    end
    
    methods(Static)
    end

    methods(Access = public)
        function this = PatternPrinter2(x,cc,Gm,q,A0,l0,Rtij,cspond,varargin)
            this = cmp_argparse(this,varargin{:});
            
            this.Gm = Gm;
            this.cc = reshape(cc,2,[]);
            this.x = x;
            this.cspond = cspond;
            this.w = ones(2*size(this.x,2),1);
            this.pack(q,A0,l0,Rtij);
        end
        
        function [] = pack(this,q,A0,l0,Rtij)
            H0 = eye(3);
            H0(1:2,1:2) = A0(1:2,1:2);
            H0(3,:) = l0';
            M = flip(eye(3));
            [Qp,Rp]  = qr((M*A0)');
            this.Q = M*Qp';
            A0 = M*Rp'*M;
            
            this.q0 = q*sum(2*this.cc)^2;
            this.A0 = reshape(A0(1:2,1:2),1,[]);
            this.l0 = l0;
            this.Rtij0 = Rtij;
            q_idx = 1;

            H_idx = [1:5]+q_idx(end);
            switch this.motion_model
              case 't'
                Rtij_idx = ...
                    [1:2*size(Rtij,3)]+H_idx(end);
                this.num_Rt_params = 2;
              case 'Rt'
                Rtij_idx = ...
                    [1:3*size(Rtij,3)]+H_idx(end);
                this.num_Rt_params = 3;
            end
            this.params =  struct('q', q_idx,'H', H_idx, 'Rtij', Rtij_idx);
            this.dz0 = zeros(this.params.Rtij(end),1);
        end
        
        function [q,H,Rtij,A,l] = unpack(this,dz)
            dq = dz(this.params.q);
            dH = dz(this.params.H);
            dRtij = reshape(dz(this.params.Rtij),this.num_Rt_params,[]);
            q = this.q0+dq;
            A = eye(3,3);
            A(1,1) = this.A0(1)+dH(1);
            A(2,1) = this.A0(2);
            A(1,2) = this.A0(3)+dH(2);
            A(2,2) = this.A0(4)+dH(3);
            A = A*this.Q;
            l = this.l0+[dH(4:5);0];
            if this.num_Rt_params == 2
                dRtij = [zeros(1,size(dRtij,2)); ...
                         dRtij];
            end
            Rtij = multiprod(this.Rtij0,Rt.params_to_mtx(dRtij));
            H = A;
            H(3,:) = transpose(l);
        end
                   
        function cost = costfun(this,dz)
            if nargin < 2
                dz = this.dz0;
            end
            [q,H,Rtij] = this.unpack(dz);            
            xp = PT.renormI(blkdiag(H,H,H)*PT.ru_div(this.x,this.cc,q/sum(2*this.cc)^2));
            cost = calc_cost(this.x,xp,this.cspond,this.Gm,q/sum(2*this.cc)^2,this.cc,H,Rtij);
            cost = reshape(cost,3,[]);
            cost = reshape(cost(1:2,:),[],1);
        end
        
        function [M,stats] = fit(this,varargin)
            err0 = this.costfun(this.dz0);
            lb = -8;
            if numel(this.dz0) <= numel(err0)
                lb = transpose([lb -inf(1,numel(this.dz0)-1)]);
                ub = transpose([0 inf(1,numel(this.dz0)-1)]);
                Jpat = this.make_Jpat();
                options = optimoptions(@lsqnonlin, ...
                                       'Algorithm', 'trust-region-reflective', ...
                                       'Display','none', ...
                                       'Display', 'iter', ...
                                       'JacobPattern',Jpat, ...
                                       varargin{:});
                costfun = @this.costfun;
                [dz,resnorm,err] = lsqnonlin(costfun,this.dz0,lb,ub,options);
            else
                dz = this.dz0;
                err = err0;
                resnorm = sum(err.^2);
            end

            [q,H,Rtij,A,l] = this.unpack(dz);

            M = struct('q',q/sum(2*this.cc)^2, ...
                       'cc', this.cc, ...
                       'A',A,'l',l, ...
                       'H',H, 'Rtij', Rtij,'Gm',this.Gm);
            
            stats = struct('dz', dz, ...
                           'resnorm', resnorm, ...
                           'err', err, ...
                           'err0', err0);            
        end
        
        function Jpat = make_Jpat(this)
        %            n = this.params.Rtij(end);
            m = 12*size(this.cspond,2);
            [dq_ii dq_jj] = meshgrid(1:m,this.params.q);
            [dH_ii dH_jj] = meshgrid(1:m,this.params.H);
            
            dRt_ii = [];dRt_jj = [];

            for k1 = 1:numel(this.Gm)
                [aa,bb] = ...
                    meshgrid(12*(k1-1)+[1:12], ...
                             [this.num_Rt_params*(this.Gm(k1)-1)+1:this.num_Rt_params* ...
                              this.Gm(k1)]+max(dH_jj(:)));
                dRt_ii = cat(1,dRt_ii,aa(:));
                dRt_jj = cat(1,dRt_jj,bb(:));
            end
            
            ii = [dq_ii(:);dH_ii(:);dRt_ii];
            jj = [dq_jj(:);dH_jj(:);dRt_jj];
            v = ones(numel(ii),1);
            Jpat = sparse(ii,jj,v,max(ii),max(jj));
             
%            costfun = @this.costfun;
%            [J,err] = jacobianest(costfun,this.dz0);
%            J(find(J)) = 1;
%            J = sparse(J);
%            
%            keyboard;
%            
            %            Rtij_idx = reshape(this.params.Rtij_idx,3,[]);
%            Rtij_ii = repmat(this.cspond(
%            Rtij_jj = repmat(Rtij_idx(:,this.Gm),12,[]);
%            
           
            %            v = ones(numel([dq_ii(:); dH_ii(:); dG_ii;dRti_dj_ii]),1);
%            Jpat = ...
%                sparse([dq_ii(:); dH_ii(:);
%                       [dq_jj(:); dH_jj(:);
%                       v,m,n);
        end
        
    end
end
