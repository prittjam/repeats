% Copyright (c) 2017 James Pritts
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
classdef coplanar_pattern < handle
    properties(Access = public)
        X,X2;
        w2,h2,dx,dy,num_rows,num_cols,num_lafs;
    end
    
    methods(Access = public)
        function this = coplanar_pattern(w2,h2,dx,dy, ...
                                         num_lafs,num_rows, ...
                                         num_cols,varargin)
            this.X = [];
            this.X2 = [];

            this.w2 = w2;
            this.h2 = h2;
            this.dx = dx;
            this.dy = dy;

            this.num_lafs = num_lafs;
            this.num_rows = num_rows;
            this.num_cols = num_cols;
        end

        function [u,x] = make_template(this)
            M = [[this.w2 0; 0 this.h2] [0 0]'; ...
                 0 0 1];
            u = blkdiag(M,M,M)*LAF.make_random(this.num_lafs);
            x = M*[0 1 1 0; ...
                   0 0 1 1; ...
                   1 1 1 1];
        end
        
        function T = make_template_xforms(this)
            m = this.num_rows*this.num_cols;
            for c = 1:this.num_cols
                for r = 1:this.num_rows
                    tx = (c-1)*this.dx+(this.dx-this.w2)/2;
                    ty = (r-1)*this.dy+(this.dy-this.h2)/2;
                    T{r,c} = [1 0 tx; ...
                              0 1 ty; ...
                              0 0 1];                        
                end
            end
        end
        
        function pts = make(this)
            [u,x] = this.make_template();
            T = this.make_template_xforms();
            ind2 = [1:this.num_lafs];

            M = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
            [G,rows,cols] = ndgrid(1:3*this.num_lafs,1:this.num_rows,1: ...
                                   this.num_cols);
            G = reshape(G,1,[]);
            rows = reshape(rows,1,[]);
            cols = reshape(cols,1,[]);

            X = [];
            for c = 1:this.num_cols
                for r = 1:this.num_rows
                    ind = this.num_lafs*this.num_cols*(r-1)+ ...
                          this.num_lafs*(c-1)+[1:this.num_lafs];
                    X = cat(2,X,M*T{r,c}*reshape(u,3,[]));
                    this.X2 = ...
                        cat(2,this.X2,M*T{r,c}*reshape(x,3,[]));
                end
            end
            this.X = X;
            pts = struct('X', mat2cell(X,4,ones(1,size(X,2))), ...
                         'G', mat2cell(G,1,ones(1,numel(G))), ...
                         'rows', mat2cell(rows,1,ones(1,numel(rows))), ...
                         'cols', mat2cell(cols,1,ones(1,numel(cols))));
        end
    end
end
