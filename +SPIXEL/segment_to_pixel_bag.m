function c = segment_to_pixel_bag(segments,img,varargin)
cfg.sigma = 0;
cfg.decimation_factor = 1;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

min_segments = min(segments(:));
max_segments = max(segments(:));
num_segments = max_segments-min_segments+1;

if cfg.sigma > 0 
    G = fspecial('gaussian',[5 5],2);
    img = imfilter(img,G,'same');
end

for active = [min_segments:max_segments]
    BW = ismember(segments,active);
    if cfg.decimation_factor == 1
        c{active} = mask_to_pixel_bag(BW,img);
    else
        X = mask_to_pixel_bag(BW,img);
        num_px = size(X,2);
        idx = randperm(num_px,ceil(1/cfg.decimation_factor*num_px));
        c{active} = X(:,idx);
    end
end