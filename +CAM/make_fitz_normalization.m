%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [A,sc] = make_fitz_normalization(cc, varargin)
     cfg.rescale = true;
     cfg = cmp_argparse(cfg, varargin{:});

     if cfg.rescale
          sc = sum(2*cc);
     else
          sc = 1;
     end

     ncc = -cc/sc;
     A = [1/sc 0        -cc(1)/sc; ...
          0       1/sc  -cc(2)/sc; ...
          0       0      1];
end 