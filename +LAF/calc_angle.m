function angle = calc_angle(u)
v1 = u(1:2,:)-u(4:5,:);
v2 = u(7:8,:)-u(4:5,:);

v1n = bsxfun(@rdivide,v1,sqrt(sum(v1.^2,1)));
v2n = bsxfun(@rdivide,v2,sqrt(sum(v2.^2,1)));

angle = acos(dot(v1n,v2n,1));