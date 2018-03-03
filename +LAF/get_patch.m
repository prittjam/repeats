function patch = get_patch(img,invA,sz,H)
if nargin < 3
	sz = 50;
end
if nargin < 4
	H = [];
end
patch = zeros(sz,sz,3);
A = inv(invA);
lin = linspace(-1,1,sz);
[x y] = meshgrid(lin,lin);
p = A*[x(:) y(:) ones(numel(x),1)]';
if ~isempty(H)
	p = renormI(H*p);
end
p = round(p);
x1 = reshape(p(1,:),sz,sz);
y1 = reshape(p(2,:),sz,sz);
[a,b] = meshgrid(1:sz,1:sz);
for i = 1:numel(a)
	patch(a(i),b(i),:) = img(y1(i),x1(i),:);
end
