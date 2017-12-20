function BW = p3x3_to_mask(u,img)
BW = zeros(size(img,1),size(img,2));
v = LAF.p3x3_to_poly(u);
for k = 1:size(v,2)
    BW0 = poly2mask(v(1:2:end,k),v(2:2:end,k), ...
                    size(BW,1),size(BW,2));
    BW = BW0 | BW;
end