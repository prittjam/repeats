function [timg,trect,T,S] = distort_kb(img, k, varargin);
    cfg = struct('border', [], 'size', size(img));
    [cfg,varargin] = cmp_argparse(cfg, varargin{:});
    T0 = make_distort_kb_xform(k, varargin{:});
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

function T = make_distort_kb_xform(k,varargin)
    T = maketform('custom',2,2, ...
                @distort_kb_xform, ...
                @undistort_kb_xform, ...
                struct('k',k,varargin{:}));
end

function v = undistort_kb_xform(u,T)
    v = CAM.undistort_kb(u',T.tdata.k,namedargs2cell(rmfield(T.tdata,'k')))';
end

function v = distort_kb_xform(u,T)
    v = CAM.distort_kb(u',T.tdata.k,namedargs2cell(rmfield(T.tdata,'k')))';
end
