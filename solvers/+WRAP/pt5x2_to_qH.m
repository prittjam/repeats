%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef pt5x2_to_qH 
    methods
        function this = pt5x2_to_qH()
        end
        
        function M = unnormalize(this,M,A,normcc)
            M.H = A\M.H*A;
            M.q = M.q/normcc;
            M.Hu = M.H;
        end
        
        function M = fit(this,x,idx,cc,varargin)           
            A = CAM.make_fitz_normalization(cc);
            invA = inv(A); 
            normcc = sum(2*invA(1:2,3))^2;
            xn = A*x(:,[idx{:}]);
            xng = transpose(reshape(xn,6,[]));
            assert(size(xng,1)==5, ...
                   'incorrect number of correspondences');

            [H1,q1] = H5rKuk(xng(:,4:5),xng(:,1:2));
            
            is_valid1 = cellfun(@(x) abs(imag(x)) < 1e-6 & ...
                                isfinite(x) & ...
                                x ~= 10000 & ...
                                ~isnan(x),q1);
            is_valid2 = cellfun(@(x) all(abs(imag(x(:))) < 1e-6), H1);

            is_valid = is_valid1 & is_valid2;

            H = cellfun(@(x) real(x), H1(is_valid), ...
                        'UniformOutput',false);
            q = cellfun(@(x) real(x), q1(is_valid), ...
                        'UniformOutput', false);

            M = struct('H', H, ...
                       'q', q, ...
                       'cc', cc);
            M = arrayfun(@(m) this.unnormalize(m,A,normcc),M);
        end
    end
end
