function P = calc_intersection(u)
n = size(u,2);
P = logical(zeros(n,n)); 
xq = u([1 4 7],:)';
yq = u([2 5 8],:)';
xq = xq(:);
yq = yq(:);
for i = 1:n
	xv = u([1 4 7],i);
	yv = u([2 5 8],i);
	in = inpolygon(xq,yq,xv,yv);
	in = in(1:n) | in(n+1:2*n) | in(2*n+1:end);
	P(i,in) = 1;
end
P(1:n+1:n*n) = 0;