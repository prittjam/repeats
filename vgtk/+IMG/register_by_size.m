function [T,S] = register_by_size(img,T0,boundary,sz,varargin)
    cfg.lockaspectratio = true;
    [cfg,leftover] = cmp_argparse(cfg,varargin{:});

    nx = sz(2);
    ny = sz(1);
    tboundary = tformfwd(T0,boundary);
    xextent = max(tboundary(:,1))-min(tboundary(:,1));
    yextent = max(tboundary(:,2))-min(tboundary(:,2));
    s = [(nx-1)/xextent (ny-1)/yextent];
    
    if cfg.lockaspectratio
        s = min(s);
        S = [s 0 0; ...
             0 s 0; ...
             0 0 1];
    else
        S = [s(1)  0     0; ...
             0     s(2)  0; ...
             0     0     1];
    end

    T = maketform('composite', ...
                  maketform('affine',S'), T0);