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
            this.q0 = q*sum(2*this.cc)^2;
            if A0(2,1) == 0
                this.A0 = A0(1:2,1:2);
            else
                this.A0 = reshape(A0(1:2,1:2),1,[]);
            end
            this.l0 = l0;
            this.Rtij0 = Rtij;
            q_idx = 1;
            switch this.motion_model
              case 't'
                H_idx = [1:3]+q_idx(end);
                Rtij_idx = ...
                    [1:2*size(Rtij,2)]+H_idx(end);
                this.num_Rt_params = 2;
              case 'Rt'
                H_idx = [1:6]+q_idx(end);
                Rtij_idx = ...
                    [1:3*size(Rtij,3)]+H_idx(end);
                this.num_Rt_params = 3;
            end
            this.params =  struct('q', q_idx,'H', H_idx, 'Rtij', Rtij_idx);
            this.dz0 = zeros(this.params.Rtij(end),1);
        end
        
        function [q,Hr,Rtij,A,l] = unpack(this,dz)
            dq = dz(this.params.q);
            dH = dz(this.params.H);
            dRtij = reshape(dz(this.params.Rtij),this.num_Rt_params,[]);
            q = this.q0+dq;
            if numel(dH) == 3
                l = this.l0+dH(1:3);
                Rtij(2:3,:) = Rtij(2:3,:)+dRtij; 
            elseif numel(dH) == 6
                %                if this.A0(2) == 0
                A = eye(3,3);
                A(1,1) = this.A0(1)+dH(1);
                A(2,1) = this.A0(2);
                A(1,2) = this.A0(3)+dH(2);
                A(2,2) = this.A0(4)+dH(3);
                l = this.l0+[dH(4:6)];
                %                else
                %                    A(1,1) = this.A0(1)+dH(1);
                %                    A(2,1) = this.A0(2)+dH(2);
                %                    A(1,2) = this.A0(3)+dH(3);
                %                    A(2,2) = this.A0(4)+dH(4);
                %                    l(1:2) =  transpose([A(1,1) A(1,2)]);
                %                    l(3) = -det(A(1:2,1:2));
                %                end
                Rtij = multiprod(this.Rtij0,Rt.params_to_mtx(dRtij));
            end
            Hr = A;
            Hr(3,:) = transpose(l);
        end
                   
        function cost = errfun(this,dz)
            if nargin < 2
                dz = this.dz0;
            end
            [q,Hinf,Rtij] = this.unpack(dz);            
            cost = calc_cost(this.x,this.cspond,this.Gm,q/sum(2*this.cc)^2,this.cc,Hinf,Rtij);
            cost = reshape(cost,3,[]);
            cost = reshape(cost(1:2,:),[],1);
        end
        
        function [M,stats] = fit(this,varargin)
            err0 = this.errfun(this.dz0);
            lb = -8;
            if numel(this.dz0) <= numel(err0)
                lb = transpose([lb -inf(1,numel(this.dz0)-1)]);
                ub = transpose([0 inf(1,numel(this.dz0)-1)]);
                options = optimoptions(@lsqnonlin, ...
                                       'Algorithm', 'trust-region-reflective', ...
                                       'Display','none', ...
                                       'Display', 'iter', ...
                                       varargin{:});
                errfun = @this.errfun;
                [dz,resnorm,err] = lsqnonlin(errfun,this.dz0,lb,ub,options);
            else
                dz = this.dz0;
                err = err0;
                resnorm = sum(err.^2);
            end

            [q,Hr,Rtij,A,l] = this.unpack(dz);

            M = struct('q',q/sum(2*this.cc)^2, ...
                       'cc', this.cc, ...
                       'A',A,'l',l, ...
                       'Hr',Hr, ...
                       'Rtij', Rtij, ...
                       'Gm',this.Gm);
            
            stats = struct('dz', dz, ...
                           'resnorm', resnorm, ...
                           'err', err, ...
                           'err0', err0);            
        end
        
%        function Jpat = make_Jpat(this)
%            n = this.params.Rtij(end);
%            [dq_ii dq_jj] = meshgrid(1:m,this.params.q);
%            [dH_ii dH_jj] = meshgrid(1:m,this.params.H);
%            
%            Rtij_idx = reshape(this.params.Rtij_idx,3,[]);
%            Rtij_ii = repmat(this.cspond(
%            Rtij_jj = repmat(Rtij_idx(:,this.Gm),12,[]);
%            
%            
%
%            v = ones(numel([dq_ii(:); dH_ii(:); dG_ii;dRti_dj_ii]),1);
%            Jpat = ...
%                sparse([dq_ii(:); dH_ii(:); dG_ii;dRti_dj_ii], ...
%                       [dq_jj(:); dH_jj(:); dG_jj;dRti_dj_jj], ...
%                       v,m,n);
%        end
        
    end
end
