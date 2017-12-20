function flag = are_same_orientation(u,l)
u = reshape(u,3,[]);
z = dot(l(:,ones(1,size(u,2))),u);
flag = all(z/z(1) > 0);
