function l = make_orthogonal(lp,x)
    l1p = lp(1,:);
    l2p = lp(2,:);
    l3p = lp(3,:);
    u = x(1,:);
    v = x(2,:);
    
    l1 = -(l2p - l3p.*v).*(1./(l1p.^2 - 2.*l1p.*l3p.*u + l2p.^2 - 2.*l2p.*l3p.*v + ...
                            l3p.^2.*u.^2 + l3p.^2.*v.^2)).^(1/2);
    
    l2 = (l1p - l3p.*u).*(1./(l1p.^2 - 2.*l1p.*l3p.*u + l2p.^2 - 2.*l2p.*l3p.*v ...
                           + l3p.^2.*u.^2 + l3p.^2.*v.^2)).^(1/2);
    
    l3 = (1./(l1p.^2 - 2.*l1p.*l3p.*u + l2p.^2 - 2.*l2p.*l3p.*v + l3p.^2.*u.^2 + l3p.^2.*v.^2)).^(1/2).*(l2p.*u - l1p.*v);
    
    l = [l1;l2;l3];
    
%    syms l1 l2 l3 l1p l2p l3p u v real 
%    l = [l1 l2 l3]';
%    lp = [l1p l2p l3p]';
%    x = [u v 1]';
%    
%    eqns = [l'.*lp == 0, l'.*x == 0, l1.^2+l2.^2 == 1 ];
%    [soll1,soll2,soll3] = solve(eqns,[l1 l2 l3]);
