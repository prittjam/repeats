classdef coplanar_pattern < handle
    properties(Access = public)
        X,X2;
        w2,h2,dx,dy,num_lafs,num_rows,num_cols,num_pts;
        do_rot;
        labels;
        ctg;
    end
    
    methods(Access = public)
        function this = coplanar_pattern(w2,h2,dx,dy, ...
                                         num_lafs,num_rows, ...
                                         num_cols,varargin)
            this.X = [];
            this.X2 = [];

            this.do_rot = false;

            this.w2 = w2;
            this.h2 = h2;
            this.dx = dx;
            this.dy = dy;

            this.num_lafs = num_lafs;
            this.num_rows = num_rows;
            this.num_cols = num_cols;
            this.num_pts = 3*this.num_lafs;

            this.labels = [];
        end
    
%        function T = make_template_xforms(this)
%            m = this.num_rows*this.num_cols;
%            dphi  = 2*pi/m;
%            phi = 0;
%            for r = 1:this.num_rows
%                for c = 1:this.num_cols
%                    cc = cos(phi);
%                    ss = sin(phi);
%                    if this.do_rot
%                        R1 = [ cc -ss  0; ...
%                               ss  cc  0; ...
%                               0   0   1];
%                        phi = phi+dphi;
%                    else
%                        R1 = eye(3);
%                    end
%                    R1(1:2,3) = [(c-1)*this.dx+(c-1)*this.w2+this.dx/2+this.w2/2 (r-1)*this.dy+(r-1)*this.h2+this.dy/2+this.h2/2]';
%                    T{r,c} = R1;
%                end
%            end
%        end
%        
        
        function T = make_template_xforms(this)
            m = this.num_rows*this.num_cols;
            dphi  = 2*pi/m;
            phi = 0;
            for r = 1:this.num_rows
                for c = 1:this.num_cols
                    cc = cos(phi);
                    ss = sin(phi);
                    if this.do_rot
                        R1 = [ cc -ss  0; ...
                               ss  cc  0; ...
                               0   0   1]*[1 0 10;0 1 0; 0 0 1];
                        phi = phi+dphi;
                    else
                        R1 = [1 0 (c-1)*10;
                              0 1 (r-1)*10; 
                              0 0        1];
                    end
                    T{r,c} = R1;
                end
            end
        end
        
        function [u2,x2] = make_template(this)
            u = [rand(2,this.num_pts); ...
                 ones(1,this.num_pts)];
            v = cross(u(:,1:3:end)-u(:,2:3:end), ... 
                      u(:,3:3:end)-u(:,2:3:end));
            s1 = repmat(v(3,:) < 0,3,1);

            ib = find(s1);
            tmp = u(:,ib(1:3:end));
            u(:,ib(1:3:end)) = u(:,ib(3:3:end));
            u(:,ib(3:3:end)) = tmp;

            M = [[this.w2 0; 0 this.h2] [-this.w2/2 -this.h2/2]'; ...
                 0 0 1]*[1 0 0; 0 -1 1; 0 0 1];
            u2 = M*u;

            x = [-0.2 1.2 1.2 -0.2; -0.2 -0.2 1.2 1.2; 1 1 1 1];
            x2 = M*x;
        end
        
        function [dr,ctg] = make(this,sp,varargin)
            cfg.outlier_pct = 0.0;
            [cfg,~] = cmp_argparse(cfg,varargin{:});

            [u,xu] = this.make_template();
            T = this.make_template_xforms();
            ind2 = [1:this.num_lafs];

            for r = 1:this.num_rows
                for c = 1:this.num_cols
                    this.X2 = cat(2,this.X2,sp.model_xform*T{r,c}*xu);
                    ind = this.num_lafs*this.num_cols*(r-1)+this.num_lafs*(c-1)+[1:this.num_lafs];
                    if cfg.outlier_pct > eps
                        pb = repmat(rand(1,size(u,2)/3) < cfg.outlier_pct,3,1);
                        pb = pb(:);

                        u2 = ones(size(u));
                        u2(:,~pb) = u(:,~pb);

                        k = sum(pb);
                        v = ones(3,k);
                        v(1:2,:) = reshape(rand(1,2*k),2,[]);
                        vz = cross(v(:,1:3:end)-v(:,2:3:end), ... 
                                   v(:,3:3:end)-v(:,2:3:end));
                        s1 = repmat(vz(3,:) < 0,3,1);
                        ib = find(s1);
                        tmp = v(:,ib(1:3:end));
                        v(:,ib(1:3:end)) = v(:,ib(3:3:end));
                        v(:,ib(3:3:end)) = tmp;

                        u2(:,pb) = [[this.w2 0; 0 this.h2] [-this.w2/2 -this.h2/2]'; ...
                                    0 0 1]*[1 0 0; 0 -1 1; 0 0 1]*v;

                        this.X = cat(2,this.X,sp.model_xform*T{r,c}*u2);

                        pb2 = all(reshape(~pb,3,[]));
                        this.labels(ind(pb2)) = ind2(pb2);
                        this.labels(ind(~pb2)) = this.num_lafs+1;
                    else
                        this.X = cat(2,this.X,sp.model_xform*T{r,c}*u);
                        this.labels(ind) = ind2;
                    end
                end            
            end
            this.ctg = struct('plane_ctgs',zeros(1,this.num_lafs+1), ...
                              'clust_ctgs',zeros(1,this.num_lafs+1), ...
                              'outlier_ctgs',zeros(1,this.num_lafs+1));
            this.ctg.plane_ctgs(1:this.num_lafs) = 1;
            this.ctg.clust_ctgs(1:this.num_lafs) = 1:this.num_lafs;
            this.ctg.outlier_ctgs(end) = 1;
        end
    end
end