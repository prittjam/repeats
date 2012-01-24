function dx = eg_sampson_err(u,F)
N = size(u,2);

S = [1 0 0 0 0 0; ...
     0 1 0 0 0 0; ...
     0 0 0 1 0 0; ...
     0 0 0 0 1 0];

l = zeros(size(u));

l(1:3,:) = F*u(1:3,:);
l(4:6,:) = F'*u(4:6,:);

e = dot(u(1:3,:),l(4:6,:));
Jt = S*l;
d2 = 1./dot(Jt,Jt,1);

invJ = zeros(size(Jt));
ia = d2 > 1e-8;

invJ(:,ia) = Jt(:,ia).*repmat(d2(ia),4,1);

for j = find(~ia)
    invJ(:,j) = pinv(Jt(:,j)');
end

dx = -invJ.*repmat(e,4,1);