classdef MleImpl2 < handle
    properties    
        x = [];
        
        q0 = [];
        Hinf0 = [];
        X0 = [];
        Rtij0 = [];
        
        rtree = [];
        Tlist = [];
        Gm = [];
        inverted = [];
        
        cc = [];
        
        M = [];
        
        params = [];
        dz0 = [];
        
        num_Rt_params = [];
        motion_model = 't';
    end
    
    methods(Static)
        function err = errfun(dz,mle_impl)
            [q,Hinf,X,Rtij] = mle_impl.unpack(dz);            
            [Gs,Rti] = composite_xforms(mle_impl.Tlist, ...
                                        mle_impl.Gm,mle_impl.inverted, ...
                                        Rtij,X,size(mle_impl.x,2));
            [Xp,inl] = sfm(X,Gs,Rti);
            Hinv = inv(Hinf);
            xp = PT.renormI(Hinv*reshape(Xp,3,[]));
            xpd = CAM.rd_div(xp,mle_impl.cc,q);
            x = reshape(mle_impl.x(:,inl),3,[]);
            err = reshape(xpd(1:2,:)-x(1:2,:),[],1);
        end
    end

    methods(Access = public)
        function this = MleImpl2(cc,x,rtree,Gs,Tlist, ...
                                 Gm,is_inverted, ...
                                 q,Hinf,X,Rtij,varargin)
            this = cmp_argparse(this,varargin{:});
            
            this.rtree = rtree;
            this.Tlist = Tlist;
            this.Gm = sparse(rtree.Edges.EndNodes(:,1), ...
                             rtree.Edges.EndNodes(:,2), ...
                             Gm);
            this.inverted = sparse(rtree.Edges.EndNodes(:,1), ...
                                   rtree.Edges.EndNodes(:,2), ...
                                   is_inverted);
            this.cc = cc;
            this.x = x;
            this.Tlist = Tlist;
            
            this.pack(q,Hinf,X,Rtij);
        end
        
        function [] = pack(this,q,Hinf,X,Rtij)
            this.q0 = q;
            this.Hinf0 = Hinf;
            this.X0 = X;
            this.Rtij0 = Rtij;
            
            q_idx = 1;
            switch this.motion_model
              case 't'
                H_idx = [1:3]+q_idx(end);
                X_idx = [1:6*size(X,2)]+H_idx(end);
                Rtij_idx = ...
                    [1:2*size(Rtij,2)]+X_idx(end);
                this.num_Rt_params = 2;
              case 'Rt'
                H_idx = [1:8]+q_idx(end);
                X_idx = [1:6*size(X,2)]+H_idx(end);
                Rtij_idx = ...
                    [1:3*size(Rtij,2)]+X_idx(end);
                this.num_Rt_params = 3;
            end
            this.params =  struct('q', q_idx,'H', H_idx, ...
                                  'X', X_idx, 'Rtij', Rtij_idx);
            this.dz0 = zeros(this.params.Rtij(end),1);
        end
        
        function [q,Hinf,X,Rtij] = unpack(this,dz)
            dq = dz(this.params.q);
            dH = dz(this.params.H);
            dX = zeros(9,size(this.X0,2));
            dX([1 2 4 5 7 8],:) = reshape(dz(this.params.X),6,[]);
            dRtij = reshape(dz(this.params.Rtij),this.num_Rt_params,[]);
            
            q = this.q0+dq;
            X = this.X0+dX;
            
            Rtij = this.Rtij0;
            if numel(dH) == 3
                Hinf = this.Hinf0;
                Hinf(3,:) = Hinf(3,:)+dH';
                Rtij(2:3,:) = Rtij(2:3,:)+dRtij;
            elseif numel(dH) == 8
                Hinf = [1+dH(1)   dH(4)   dH(7); ...
                        dH(2)    1+dH(5)  dH(8); ...
                        dH(3)     dH(6)     1  ]*this.Hinf0;
                Rtij(1:3,:) = this.Rtij0(1:3,:)+dRtij;                
            end
        end
        
        function Jpat = make_Jpat(this)
            active_vertices = unique(this.rtree.Edges.EndNodes);
            M = 6*numel(active_vertices);
            [dq_ii dq_jj] = meshgrid(1:M,this.params.q);
            [dH_ii dH_jj] = meshgrid(1:M,this.params.H);

            AA = [];BB = [];
            for k = 1:numel(this.Tlist)
                [TR,D] = shortestpathtree(this.rtree,this.Tlist{k}(1), ...
                                          'OutputForm','cell');
                sz = cellfun(@(x) numel(x),TR);
                idx = find(sz > 0);
                for k2 = 1:numel(idx)
                    [aa,bb] = meshgrid(6*(k2-1)+[1:6]',TR{idx(k2)}+this.params.H(end));
                    AA = cat(1,AA,aa);
                    BB = cat(1,BB,bb);
                end

                idx2 = find(sz > 1);
                keyboard;
                for k2 = 1:numel(idx2)
                    edg_idx = [1:numel(TR{idx2(k2)})-1; ...
                               2:numel(TR{idx2(k2)})]';
                    tr = TR{idx2(k2)};
                    b = this.edge_data.Gm(sub2ind(size(this.edge_data.Gm), ...
                                                  tr(edg_idx(:,1)),tr(edg_idx(:,2))));
                    [aa,bb] = meshgrid(6*(k2-1)+[1:6]',TR{idx(k2)}+this.params.H(end));
                    AA = cat(1,AA,aa);
                    BB = cat(1,BB,bb);                    
                end
            end
            Jpat = [];
        end

        
        function err = calc_err(this,dz)
            if nargin < 2
                dz = this.dz0;
            end
            err = MleImpl2.errfun(dz,this);
        end 
                
        function [M,stats] = fit(this,varargin)
            err0 = this.calc_err();
            options = optimoptions('lsqnonlin','Display','iter', 'MaxIter',15);
            %            Jpat = this.make_Jpat();
            [dz,resnorm,err] = lsqnonlin(@(dz) MleImpl2.errfun(dz,this), ...
                                         this.dz0,[],[],options);
            [q,H,X,Rtij] = this.unpack(dz);
            [Gs,Rti] = composite_xforms(this.Tlist, ...
                                        this.Gm,this.inverted, ...
                                        Rtij,X,size(this.x,2));
            [Xp,inl] = sfm(X,Gs,Rti);
            
            M = struct('q',q,'cc', this.cc, ...
                       'H',H,'X',X', ...
                       'Rti', Rti,'Gs',Gs);
            
            stats = struct('dz', dz, ...
                           'resnorm', resnorm, ...
                           'err', err, ...
                           'err0', err0, ...
                           'sqerr0', sum(reshape(err0,6,[]).^2), ...
                           'sqerr', sum(reshape(err,6,[]).^2));
        end
    end
end
