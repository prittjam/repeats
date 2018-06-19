function l = make_orthogonal(lp,x)
    l = LINE.inhomogenize(lp);
    tmp = l(1,:);
    l(1,:) = -l(2,:);
    l(2,:) = tmp;
    l(3,:) = -dot(l(1:2,:),x(1:2,:)); 
