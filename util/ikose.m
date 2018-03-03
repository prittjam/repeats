function sk = ikose(r,k,n)
m = numel(r);

kappa = k/n;
skold = inf;
r2 = sort(abs(r));
E = 3;

while (true)
    sk = r2(k)/norminv((1+kappa)/2,0,1);
    
    if (kappa < 1) & (skold == sk)
        break;
    end
    skold = sk;

    n = sum(r2/sk < E);
    kappa = k/n;
end
