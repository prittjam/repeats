function [] = find_pixels(img,px)
img3 = permute(img,[3 1 2]);
X = reshape(img3(find(BW3)),3,[]);
ismember(X',px');
