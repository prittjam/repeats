function lognck = orsa_make_logcombi_k(N,K)
lognck = zeros(1,N);

for n = K:N
    lognck(n) = sum(log10(n-[0:K-1])-log10(1:K));
end
