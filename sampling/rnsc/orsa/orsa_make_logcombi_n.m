function lognck = orsa_make_logcombi_n(N,K)
lognck = zeros(1,N);

for k = 1:N
    lognck(k) = sum(log10(N-[0:k-1])-log10(1:k));
end