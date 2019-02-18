%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function a = mtx_to_params(M)
a = zeros(4,size(M,3));
a(1,:) = atan2(M(2,1,:),M(1,1,:));
a(2:3,:) = M([1 2],3,:);
a(4,:) = M(1,1,:).*M(2,2,:)-M(2,1,:).*M(1,2,:);