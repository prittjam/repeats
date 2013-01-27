function rootSIFTs = sift_calc_rootSIFT(sifts)
sifts = double(sifts);
rootSIFTs = sqrt(bsxfun(@rdivide,sifts,sum(abs(sifts),1)));