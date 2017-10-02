function lh = draw(ax1,l,varargin)
axes(ax1);
v = axis;
n = size(l,2);

top = repmat(cross([v(1) v(3) 1]',[v(2) v(3) 1]'),1,n);
bottom = repmat(cross([v(1) v(4) 1]',[v(2) v(4) 1]'),1,n);
left = repmat(cross([v(1) v(3) 1]',[v(1) v(4) 1]'),1,n);
right = repmat(cross([v(2) v(3) 1]',[v(2) v(4) 1]'),1,n);

pts = [LINE.intersect(l,top);...
       LINE.intersect(l,bottom);...
       LINE.intersect(l,left);...
       LINE.intersect(l,right)];

ia = [repmat((pts(1,:) > v(1)) & (pts(1,:) < v(2)),2,1);...
      repmat((pts(3,:) > v(1)) & (pts(3,:) < v(2)),2,1);...
      repmat((pts(6,:) > v(3)) & (pts(6,:) < v(4)),2,1);...
      repmat((pts(8,:) > v(3)) & (pts(8,:) < v(4)),2,1)];

pts2 = reshape(pts(ia(:)),2,[]);

hold on;
lh = line(reshape(pts2(1,:),2,[]), ...
          reshape(pts2(2,:),2,[]),varargin{:});
hold off;

set(lh, ...
    'LineWidth', 1.75);