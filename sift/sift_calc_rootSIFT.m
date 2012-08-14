function rootSIFTs = sift_calc_rootSIFT(sifts)
rootSIFTs = sqrt(bsxfun(@rdivide,sifts,sum(sifts,1)));