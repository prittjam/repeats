%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = vp_linear(X)
    L = cross(X(1:3,:),X(4:6,:),1);
    L = L./repmat(sqrt(sum(L.^2)),[3 1]);
    [U,S,V] = svd(L*L');
    v = V(:,end);
    v = v/v(3);
end
