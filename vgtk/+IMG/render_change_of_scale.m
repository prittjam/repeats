
nx = sz(2);
    ny = sz(1);

    if size(x,2) > 1
        xp =  PT.renormI(H*CAM.ru_div(x,cc,q));
        idx = convhull(xp(1,:),xp(2,:));
        mux = mean(xp(:,idx),2);
        refpt = CAM.rd_div(PT.renormI(inv(H)*mux),cc,q);
    else
        refpt = x;
    end  
    l = transpose(H(3,:));
    l = l/l(3);
    [sc_img,si_fn] = IMG.calc_dscale(sz,l,cc,q);
    if q == 0
        ref_sc = si_fn(l(1),l(2),1,refpt(1),refpt(2));
    else
        A = [1 0 -cc(1); ...
             0 1 -cc(2); ...
             0 0      1];
        ptn = A*refpt;        
        ln = PT.renormI(inv(A)'*l);
        ref_sc = si_fn(1,ln(1),ln(2),q,1,ptn(1),ptn(2));
    end
    
    sc_img = sc_img/ref_sc;
