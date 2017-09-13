function v = rd_div(u,cc,lambda)
v = u;

if abs(lambda) > 1e-9
    if (size(u,1) == 2)
        v = PT.homogenize(u);
    end
    
    sc = sum(2*cc);
    A = [1/sc   0  -cc(1)/sc; ...
         0   1/sc  -cc(2)/sc; ...
         0     0       1];
    v = A*v;
    xu = v(1,:);
    yu = v(2,:);
    
    v(1,:) = ...
        0.5*xu./(lambda*yu.^2+xu.^2*lambda).*(1-sqrt(1-4*lambda*yu.^2-4*xu.^2*lambda));
    v(2,:) = ...
        0.5*yu./(lambda*yu.^2+xu.^2*lambda).*(1-sqrt(1-4*lambda*yu.^2-4*xu.^2*lambda));
    v = inv(A)*v;
    
    if (size(u,1) == 2)
        v = v(1:2,:);
    end
end
