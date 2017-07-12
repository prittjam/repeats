function [lh,pts2] = draw_extents(ax1,l,varargin)
v = axis;
c = [mean([v(1) v(2)]); mean([v(3) v(4)])];

n = size(l,2);

top = repmat(cross([v(1) v(3) 1]',[v(2) v(3) 1]'),1,n);
bottom = repmat(cross([v(1) v(4) 1]',[v(2) v(4) 1]'),1,n);
left = repmat(cross([v(1) v(3) 1]',[v(1) v(4) 1]'),1,n);
right = repmat(cross([v(2) v(3) 1]',[v(2) v(4) 1]'),1,n);

pts = [PT.renormI(cross(l,top,1)); 
       PT.renormI(cross(l,bottom,1));  ...
       PT.renormI(cross(l,left,1)); 
       PT.renormI(cross(l,right,1))];

pts = reshape(pts([1 2 4 5 7 8 10 11],:),2,[]);

r = reshape(sqrt(sum(bsxfun(@minus,pts,c).^2)),4,[]);
[~,I] = sort(r,1);
tmp = pts(:,I(1:2));

x = reshape(tmp(1:2:end),[],1);
y = reshape(tmp(2:2:end),[],1);

line(x,y,varargin{:});
axis tight;
