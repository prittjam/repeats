function [timg,T,A] = ru_div_rectify(img,cc,H,q,varargin)
    [ny,nx,~] = size(img);
    cfg.referencepoint = [];
    cfg.minscale = 0;
    cfg.maxscale = inf;
    [cfg,varargin] = cmp_argparse(cfg,varargin{:});

    dims = [ny nx];
    border = [];
    ru_xform = [];
    l = transpose(H(3,:));
    l = l/l(3);

    if ~isempty(cfg.referencepoint)
        border = calc_border(dims,l,cc,q, ...
                             cfg.minscale,cfg.maxscale, ...
                             cfg.referencepoint);
    end

    if q ~= 0
        ru_xform = CAM.make_ru_div_tform(cc,q);
    end

    if isempty(border)
        [timg,T,A] = IMG.rectify(img,H, ...
                                 'ru_xform', ru_xform, varargin{:});

    else
        [timg,T,A] = IMG.rectify(img,H, ...
                                 'border', border, ...
                                 'ru_xform', ru_xform, varargin{:});
    end

function border = calc_border(dims,l,cc,q, ...
                              minscale,maxscale,pt)
    [sc_img,si_fn] = IMG.calc_dscale(dims,l,cc,q);
    ref_sc = si_fn(l(1),l(2),q,1,pt(1),pt(2));
    sc_img = sc_img/ref_sc;

    mask = (sc_img > minscale) & (sc_img < maxscale);
    [ii,jj] = find(mask);
    idx = convhull(ii,jj);
    border = [jj(idx) ii(idx)];