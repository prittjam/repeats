function [] = draw_segments(gca,segments,varargin)
cfg.active = [];
cfg.ColorMap = distinguishable_colors(max(segments(:)));
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

imagesc(segments);
colormap(cfg.ColorMap);