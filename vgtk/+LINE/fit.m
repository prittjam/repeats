function l = fit(x)
%Xu = mat2cell(x(1:2,:),2,ones(1,size(x,2)));
%L = cv.fitLine(Xu);
%l = ...
%    LINE.inhomogenize(LINE.make_orthogonal(L(1:2),L(3:4)));

mux = mean(x(1:2,:));
xx = x(1:2,:)-mux;
[~,~,V] = svd(xx*xx');
l = V(:,end);
LINE.inhomogenize(LINE.make_orthogonal(l,mux));
