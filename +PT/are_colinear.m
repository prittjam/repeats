%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function flag = are_colinear(u,T)
if nargin < 2
    T = 0.05;
end 
assert(size(u,1)==3);
m = size(u,1);
n = size(u,2);
v = bsxfun(@minus,u,mean(u,2));
[w,~,latent] = pca(v');
latent = sort(latent,'descend');
flag = latent(2)/latent(1) < T;
