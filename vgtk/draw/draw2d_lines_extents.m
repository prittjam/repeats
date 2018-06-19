function lh = draw2d_lines_extents(ax1,l,varargin)
%axes(ax1);
v = axis;
n = size(l,2);

top = repmat(cross([v(1) v(3) 1]',[v(2) v(3) 1]'),1,n);
bottom = repmat(cross([v(1) v(4) 1]',[v(2) v(4) 1]'),1,n);
left = repmat(cross([v(1) v(3) 1]',[v(1) v(4) 1]'),1,n);
right = repmat(cross([v(2) v(3) 1]',[v(2) v(4) 1]'),1,n);

pts = [line_intersect(l,top);...
       line_intersect(l,bottom);...
       line_intersect(l,left);...
       line_intersect(l,right)];

[~,ind1] = min(pts(1:2:end,:));
[~,ind2] = max(pts(1:2:end,:));

ind1i = [2*ind1-1; ...
         2*ind1];
ind1j = [1:size(ind1,2); ...
         1:size(ind1,2)];
ind1 = sub2ind(size(pts),ind1i,ind1j);

ind2i = [2*ind2-1; ...
         2*ind2];
ind2j = [1:size(ind2,2); ...
         1:size(ind2,2)];
ind2 = sub2ind(size(pts),ind2i,ind2j);

pts2 =  reshape([pts(ind1) pts(ind2)],2,[]);

hold on;
plot(ax1,reshape(pts2(1,:),2,[]),reshape(pts2(2,:),2,[]),varargin{:});
hold off;

axis tight;