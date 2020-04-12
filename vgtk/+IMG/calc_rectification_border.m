function [border,sc_img] = calc_rectification_border(sz,l,cc,q,minscale,maxscale,x)
    nx = sz(2);
    ny = sz(1);

    l = PT.renormI(l);
    
    [sc_img,si_fn] = IMG.render_scale_change(sz,l,cc,q,x);
     
    bw = (sc_img > minscale) & (sc_img < maxscale);
    [yy,xx] = find(bw);

    idx = convhull(xx,yy,'simplify',true);
    xq = xx(idx);
    yq = yy(idx);
    
    nbw = ~bw;
    [L,n] = bwlabeln(nbw);
    
    if n > 0 
        for k = 1:n
            [yy,xx] = find(L == k);
            idx = convhull(xx,yy,'simplify',true);
            xv = xx(idx(1:end-1));
            yv = yy(idx(1:end-1));
            bad = inpolygon(xq,yq,xv,yv);
            border = [xq(~bad) yq(~bad)];
        end
    else
        border = [xq yq];
    end