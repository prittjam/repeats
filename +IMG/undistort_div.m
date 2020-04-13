%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [timg,trect,T,S] = undistort_div(img,q,varargin)
    cfg = struct('border', [], 'size', size(img));
    cfg = cmp_argparse(cfg,varargin{:});
    T0 = make_undistort_div_xform(q);

    nx = size(img,2);
    ny = size(img,1);

    if ~isempty(cfg.border)
        border = cfg.border;
    else
        border = [1  1; ...
                nx 1; ...    
                nx ny; ...
                1  ny];
    end

    [T,S] = IMG.register_by_size(T0,border,cfg.size, ...
                                'LockAspectRatio', false);

    tbounds = tformfwd(T,border);

    minx = min(tbounds(:,1));
    maxx = max(tbounds(:,1));
    miny = min(tbounds(:,2));
    maxy = max(tbounds(:,2));

    timg = imtransform(img,T,'bicubic', ...
                    'XYScale',1, ...
                    'XData',[minx maxx], ...
                    'YData',[miny maxy], ...
                    'Fill',transpose([255 255 255]));

    trect = [minx miny maxx maxy];
end

function T = make_undistort_div_xform(q)
    T = maketform('custom', 2, 2, ...
                @undistort_div_xform, ...
                @distort_div_xform, ...
                struct('q',q));
end

function v = undistort_div_xform(u, T)
    v = CAM.undistort_div(u', T.tdata.q)';
end

function v = distort_div_xform(u, T)
    v = CAM.distort_div(u', T.tdata.q)';
end
