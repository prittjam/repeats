%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function lognck = orsa_make_logcombi_n(N,K)
lognck = zeros(1,N);

for k = 1:N
    lognck(k) = sum(log10(N-[0:k-1])-log10(1:k));
end