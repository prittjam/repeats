function [T,S] = register_by_size(img,T0,border0,sz,varargin)
    cfg.lockaspectratio = true;
    [cfg,leftover] = cmp_argparse(cfg,varargin{:});

    nx = sz(2);
    ny = sz(1);
    tborder0 = tformfwd(T0,border0);
    xextent = max(tborder0(:,1))-min(tborder0(:,1));
    yextent = max(tborder0(:,2))-min(tborder0(:,2));
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