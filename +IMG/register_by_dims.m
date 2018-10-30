function [T,S] = register_by_dims(img,T0,border0,dims)
    tborder0 = tformfwd(T0,border0);
    xextent = max(tborder0(:,1))-min(tborder0(:,1))+1;
    yextent = max(tborder0(:,2))-min(tborder0(:,2))+1;
    s = min([dims(2)/xextent dims(1)/yextent]);
    S = [s 0 0;
         0 s 0;
         0 0 1];
    T = maketform('composite', ...
                  maketform('affine',S'), ...
                  T0);
%    tbounds = tformfwd(T,border0);
%
%    minx = round(min(tbounds(:,1)));
%    maxx = round(max(tbounds(:,1)));
%    miny = round(min(tbounds(:,2)));
%    maxy = round(max(tbounds(:,2)));
