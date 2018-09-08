%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function M = mtx_inv_2x2(C)
A = reshape(cell2mat(C),2,2,[]);
M = [ A(2,2,:) -A(1,2,:)
     -A(2,1,:)  A(1,1,:) ] ;
M = bsxfun(@rdivide,M,A(1,1,:).*A(2,2,:)-A(1,2,:).*A(2,1,:));
M = mat2cell(M);
