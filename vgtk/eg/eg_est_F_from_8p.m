function F = eg_est_F_from_8p(u)
n = size(u,2);

v1 = renormI(u(1:3,:));
v2 = renormI(u(4:6,:));

if n > 8
    H1 = make_hartley_xform(v1);
    H2 = make_hartley_xform(v2);
    p1 = (H1*v1)';
    p2 = (H2*v2)';
else
    p1 = v1';
    p2 = v2';
end
    
M = [ p2(:,1).*p1(:,1) p2(:,1).*p1(:,2) p2(:,1).*p1(:,3) p2(:,2).*p1(:,1) ...
      p2(:,2).*p1(:,2) p2(:,2).*p1(:,3) p2(:,3).*p1(:,1) p2(:,3).*p1(:,2) ...
      p2(:,3).*p1(:,3) ];

[~,~,v] = svd(M);
G = reshape(v(:,end),3,3)';

[u,d,v] = svd(G);
d(end,end) = 0;
F = u*d*v';

%Ft = u2F(u([1:2 3:4],s)');
%F = Ft';

if n > 8
    F = H2'*F*H1;
end

function varargout = make_hartley_xform(pts)
if size(pts,1) ~= 3
    error('pts must be 3xN');
end

% Find the indices of the points that are not at infinity
finiteind = find(abs(pts(3,:)) > eps);

if length(finiteind) ~= size(pts,2)
    warning('Some points are at infinity');
end

% For the finite points ensure homogeneous coords have s of 1
pts(1,finiteind) = pts(1,finiteind)./pts(3,finiteind);
pts(2,finiteind) = pts(2,finiteind)./pts(3,finiteind);
pts(3,finiteind) = 1;

c = mean(pts(1:2,finiteind)')';            % Centroid of finite points
newp(1,finiteind) = pts(1,finiteind)-c(1); % Shift origin to centroid.
newp(2,finiteind) = pts(2,finiteind)-c(2);

meandist = mean(sqrt(newp(1,finiteind).^2 + newp(2,finiteind).^2));

s = sqrt(2)/meandist;

varargout{ 1 } = [s  0  -s*c(1); ...
                  0  s  -s*c(2); ...
                  0  0     1];

if nargout > 1
    varargout{ 2 } = [1/s  0  c(1); ...
                      0  1/s c(2); ...
                      0   0   1];
end