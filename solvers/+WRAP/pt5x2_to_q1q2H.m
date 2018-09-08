%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef pt5x2_to_q1q2H < Solver
    properties
        A = [];
        invA = [];
        normcc;
    end
    
    methods
        function this = pt5x2_to_q1q2H(cc)
            this.A = CAM.make_fitz_normalization(cc);
            this.invA = inv(this.A); 
            this.normcc = sum(2*this.invA(1:2,3))^2;
        end
        
        function M = unnormalize(this,M)
            M.Hu = this.invA*M.Hu*this.A;
            M.q1 = M.q1/this.normcc;
            M.q2 = M.q2/this.normcc;
            M.q = (M.q1+M.q2)/2;
        end
        
        function M = fit(this,x,corresp,idx,varargin)
            m  = corresp(:,idx);
            xn = this.A*x(:,m);
            xng = transpose(reshape(xn,6,[]));            

            assert(size(xng,1)==5, ...
                   'incorrect number of correspondences');
            [H q1 q2] = H5r1r2(xng(:,4:5),xng(:,1:2));

            is_valid1 =  abs(imag(q1)) < 1e-6 & ...
                isfinite(q1) & ...
                q1 ~= 10000 & ...
                ~isnan(q1);
            is_valid2 = cellfun(@(x) all(abs(imag(x(:))) < 1e-6),H);

            is_valid = is_valid1 & is_valid2;          
                        
            M = [];
            
            n = sum(is_valid);
            if n > 0
                H = cellfun(@(x) real(x),H(is_valid),'UniformOutput',false);
                q1 = arrayfun(@(x) real(x),q1(is_valid));
                q2 = arrayfun(@(x) real(x),q2(is_valid));                                                 M = struct('Hu',H,...
                           'q1',mat2cell(q1,1,ones(1,n)), ...
                           'q2',mat2cell(q2,1,ones(1,n)));
                M = arrayfun(@(m) this.unnormalize(m),M);
            end
        end
    end
end
