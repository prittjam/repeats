function c = label_to_cell(segments,img,varargin)
cfg.blur = false;
cfg.sampling_ratio = 1;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

min_segments = min(segments(:));
max_segments = max(segments(:));
num_segments = max_segments-min_segments+1;

if cfg.blur
    G = fspecial('gaussian',[5 5],2);
    img = imfilter(img,G,'same');
end

for active = [min_segments:max_segments]
    [~,BW] = SPIXEL.get_active(segments,active);
    if cfg.sampling_ratio == 1
        c{active} = mask_to_pixels(BW,img);
    else
        X = mask_to_pixels(BW,img);
        num_px = size(X,2);
        idx = ...
            randperm(num_px,ceil(cfg.sampling_ratio*num_px));
        c{active} = X(:,idx);
    end
end