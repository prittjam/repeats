%
%  Copyright (c) 2018 James Pritts, Denys Rozumnyi
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts and Denys Rozumnyi
%
function [] = draw_segments(gca,segments,varargin)
cfg.active = [];
cfg.ColorMap = distinguishable_colors(max(segments(:)));
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

imagesc(segments);
colormap(cfg.ColorMap);