function pimg = color_map(segments,img,range)
min_segments = min(segments(:));
max_segments = max(segments(:));
num_segments = max_segments-min_segments+1;
pimg = img;
mpdc = uint8(255*distinguishable_colors(max_segments));
if nargin < 3
	range = [1:max_segments];
end

for active = range
    BW = ismember(segments,active);
    bag = mask_to_pixel_bag(BW,img);
    mpixel = mpdc(active,:)';
    BW3(:,:,1) = BW; BW3(:,:,2) = BW; BW3(:,:,3) = BW;
    pixels = repmat(mpixel,1,size(bag,2))';
    pimg(BW3) = pixels(:);
end