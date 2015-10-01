function gmm = mask_to_gmm(BW,img)
BW3 =  permute(repmat(p3x3_to_mask(u,img),[1 1 3]),[3 1 2]);
img3 = permute(img,[3 1 2]);
px = reshape(img3,3,[]);
