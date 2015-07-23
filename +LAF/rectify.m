function v = rectify(u,l)
u2 = reshape(u,3,[]);
[a,b] = meshgrid(1:size(l,2),1:size(u2,2));

a = reshape(a,1,[]);
b = reshape(b,1,[]);
u2b = u2(:,b);
z3 = dot(u2b,l(:,a),1);
u3 = u2b./z3([1 1 1],:);
u3(end,:) = 1; 
v = reshape(u3,9,[]);