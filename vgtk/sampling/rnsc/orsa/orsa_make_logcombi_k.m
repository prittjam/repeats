%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function lognck = orsa_make_logcombi_k(N,K)
lognck = zeros(1,N);

for n = K:N
    lognck(n) = sum(log10(n-[0:K-1])-log10(1:K));
end
