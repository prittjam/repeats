function H = laf3x1_to_Hinf(u)
    H = eye(3,3);
    for k = 1:3
        v = LAF.renormI(blkdiag(H,H,H)*u);
        mu = [(v(1:2,:)+v(4:5,:)+v(7:8,:))/3];                
        sc = 1./nthroot(LAF.calc_scale(v),3);
        Hk = laf3x1_to_Hinf_internal(mu,sc);
        H = Hk*H;
    end    

function H = laf3x1_to_Hinf_internal(X,rsc)    
    tx = mean(X(1,:));
    ty = mean(X(2,:));
    X(1,:) = X(1,:) - tx;
    X(2,:) = X(2,:) - ty;
    dsc = max(abs(X(:)));
    
    X = X / dsc;

    A = eye(3);
    A([1,2],3) = -[tx ty] / dsc;
    A(1,1) = 1 / dsc;
    A(2,2) = 1 / dsc;
    
    sc_norm = min(abs(rsc));
    
    Z = [X(1,:); X(2,:); -sc_norm./rsc(:)']';
    
    hs = pinv(Z) * -ones(size(X,2),1);
    
    H = eye(3);
    
    H(3,1) = hs(1);
    H(3,2) = hs(2);
    
    H = H*A;