function d = orthodist(x, c, varargin)
    % squared orthogonal distances from points x
    % to a circle c = [xc...; yc...; r...]
    cfg.mean = true;
    cfg = cmp_argparse(cfg, varargin{:});
    d = (sqrt(sum((x(1:2,:) - c(1:2,:)).^2, 1)) - c(3,:)).^2;
    if cfg.mean
        d = mean(d);
    end
end