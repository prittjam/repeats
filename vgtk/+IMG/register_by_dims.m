function [T,S] = register_by_dims(img,T0,border0,nx,ny)
    tborder0 = tformfwd(T0,border0);
    xextent = max(tborder0(:,1))-min(tborder0(:,1));
    yextent = max(tborder0(:,2))-min(tborder0(:,2));
    s = min([nx/xextent ny/yextent]);
    S = [s  0  0;
         0  s  0;
         0  0  1];
    T = maketform('composite', maketform('affine',S'), T0);