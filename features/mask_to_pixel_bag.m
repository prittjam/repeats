function X = mask_to_pixels(BW,img)
BW3 =  permute(repmat(BW,[1 1 3]),[3 1 2]);
img3 = permute(img,[3 1 2]);
X = reshape(img3(find(BW3)),3,[]);