function v = reverse_orientation(u)
m = size(u,1);
u = reshape(u,3,[]);
v = reshape(u(:,end:-1:1),m,[]);