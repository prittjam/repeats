function flag = are_same_orientation(u,l)
z = dot(l(:,ones(1,size(u,2))),u);
flag = any(z/z(1) <= 0);