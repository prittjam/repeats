function v = rd_div(u0,cc,lambda)
if (size(u0,1) == 2)
    u0 = [u0;ones(1,size(u0,2))];
end

v = u0;

if abs(lambda) > eps
    sc = sum(2*cc);
    A = [1/sc   0  -cc(1)/sc; ...
         0   1/sc  -cc(2)/sc; ...
         0     0       1];
    u = A*u0;
    xu = u(1,:);
    yu = u(2,:);
    v(1,:) = 1./2*xu./(lambda*yu.^2+xu.^2*lambda).*(1-(1-4*lambda*yu.^2-4*xu.^2*lambda).^(1/2));
    v(2,:) = 1./2./(lambda*yu.^2+xu.^2*lambda).*(1-(1-4*lambda*yu.^2-4*xu.^2*lambda).^(1/2)).*yu;
    v = inv(A)*v;
end

v = v(1:2,:);
