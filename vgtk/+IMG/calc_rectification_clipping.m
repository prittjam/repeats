function border = calc_rectification_clipping(dims,l,cc,q,minscale,maxscale,pt)
    [sc_img,si_fn] = IMG.calc_dscale(dims,l,cc,q);
    if q == 0
        ref_sc = si_fn(l(1),l(2),1,pt(1),pt(2));
    else
        A = [1 0 -cc(1); ...
             0 1 -cc(2); ...
             0 0      1];
        ptn = A*[pt(1) pt(2) 1]';        
        ref_sc = si_fn(l(1),l(2),q,1,ptn(1),ptn(2));
    end
    sc_img = sc_img/ref_sc;
    mask = (sc_img > minscale) & (sc_img < maxscale);
    [ii,jj] = find(mask);
    idx = convhull(ii,jj);
    border = [jj(idx) ii(idx)];