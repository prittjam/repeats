%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef pt5x2_to_qH < Solver
    properties
        A = [];
        invA = [];
        normcc;
    end
    
    methods
        function this = pt5x2_to_qH(cc)
            this.A = CAM.make_fitz_normalization(cc);
            this.invA = inv(this.A); 
            this.normcc = sum(2*this.invA(1:2,3))^2;
        end
        
        function M = unnormalize(this,M)
            M.Hu = this.invA*M.Hu*this.A;
            M.q = M.q/this.normcc;
        end
        
        function M = fit(this,x,corresp,idx,varargin)
            m  = corresp(:,idx);
            xn = this.A*x(:,m);
            xng = transpose(reshape(xn,6,[]));
            
            assert(size(xng,1)==5, ...
                   'incorrect number of correspondences');
            [H q] = H5rKuk(xng(:,4:5),xng(:,1:2));

            is_valid1 = cellfun(@(x) abs(imag(x)) < 1e-6 & ...
                                isfinite(x) & ...
                                x ~= 10000 & ...
                                ~isnan(x),q);
            is_valid2 = cellfun(@(x) all(abs(imag(x(:))) < 1e-6),H);

            is_valid = is_valid1 & is_valid2;

            H = cellfun(@(x) real(x),H(is_valid),'UniformOutput',false);
            q = cellfun(@(x) real(x),q(is_valid),'UniformOutput',false);
            
            M = struct('Hu',H,'q',q);
            M = arrayfun(@(m) this.unnormalize(m),M);
        end
    end
end
