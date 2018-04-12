function pimg = mean_values(segments,img)
min_segments = min(segments(:));
max_segments = max(segments(:));
num_segments = max_segments-min_segments+1;
pimg = img;
for active = [min_segments:max_segments]
    BW = ismember(segments,active);
    bag = mask_to_pixel_bag(BW,img);
    mpixel = mean(bag')';
    BW3(:,:,1) = BW; BW3(:,:,2) = BW; BW3(:,:,3) = BW;
    pixels = repmat(mpixel,1,size(bag,2))';
    pimg(BW3) = pixels(:);
end