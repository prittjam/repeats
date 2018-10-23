%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [rimg,trect,T,A,refpt] = render_rectification(img,H,cc,q,v,varargin)
cfg = struct('minscale', 0.1, ...
             'maxscale', 5); 
cfg = cmp_argparse(cfg,varargin{:});

[ny,nx,~] = size(img);
x =  PT.renormI(H*CAM.ru_div(v,cc,q));
idx = convhull(x(1,:),x(2,:));
mux = mean(x(:,idx),2);

refpt = CAM.rd_div(PT.renormI(inv(H)*mux),cc,q);

dims = [ny nx];

border = IMG.calc_dscale_border(dims,transpose(H(3,:)),cc,q, ...
                                cfg.minscale,cfg.maxscale,refpt);
[rimg,trect,T,A] = ...
    IMG.ru_div_rectify(img,cc,H,q,'Fill', [255 255 255]', ...
                       'Border', border,'CSpond', v, ...
                       'Dims', dims, 'Registration', 'Similarity');