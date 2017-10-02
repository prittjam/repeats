function un = add_noise(u,ccd_sigma)
N = size(u,2);
if (ccd_sigma > 0)
    un = u+[normrnd(0,ccd_sigma,[2 N]); ...
              zeros(1,N)];
else 
    un = u;
end
