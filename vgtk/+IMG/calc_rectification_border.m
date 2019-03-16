function border = calc_rectification_border(dims,H,cc,q,minscale,maxscale,x)
    nx = dims(2);
    ny = dims(1);

    if size(x,2) > 1
        xp =  PT.renormI(H*CAM.ru_div(x,cc,q));
        idx = convhull(xp(1,:),xp(2,:));
        mux = mean(xp(:,idx),2);
        refpt = CAM.rd_div(PT.renormI(inv(H)*mux),cc,q);
    else
        refpt = x;
    end  
    l = transpose(H(3,:));

    [sc_img,si_fn] = IMG.calc_dscale(dims,l,cc,q);
    if q == 0
        ref_sc = si_fn(l(1),l(2),1,refpt(1),refpt(2));
    else
        A = [1 0 -cc(1); ...
             0 1 -cc(2); ...
             0 0      1];
        ptn = A*refpt;        
        ln = inv(A)'*l;
        ref_sc = si_fn(1,ln(1),ln(2),q,1,ptn(1),ptn(2));
    end
    
    sc_img = sc_img/ref_sc;
    bw = (sc_img > minscale) & (sc_img < maxscale);
    bw = imerode(bw,strel('square',20));
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