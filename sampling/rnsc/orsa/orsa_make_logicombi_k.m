function lognck = orsa_make_logicombi_k(N,K)
lognck = zeros(1,N);

for n = K+1:nmax
    lognck(k) = sum(log10(n-[0:K-1])-log10(1:K));
end