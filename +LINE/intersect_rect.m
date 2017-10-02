function [pts,rect_lines] = intersect_rect(l,v)
n = size(l,2);

top = repmat(cross([v(1) v(3) 1]',[v(2) v(3) 1]'),1,n);
bottom = repmat(cross([v(1) v(4) 1]',[v(2) v(4) 1]'),1,n);
left = repmat(cross([v(1) v(3) 1]',[v(1) v(4) 1]'),1,n);
right = repmat(cross([v(2) v(3) 1]',[v(2) v(4) 1]'),1,n);

pts = [PT.renormI(cross(l,top,1)) ...
       PT.renormI(cross(l,bottom,1))  ...
       PT.renormI(cross(l,left,1)) ...
       PT.renormI(cross(l,right,1))];

mask = [ pts(1,:) < v(2)+1e4*eps & pts(1,:) > v(1)-1e4*eps; ...
         pts(2,:) < v(4)+1e4*eps & pts(2,:) > v(3)-1e4*eps] ;
mask = mask(1,:) & mask(2,:);

pts = pts(:,mask);

rect_lines = [top bottom left right];
rect_lines = rect_lines(:,mask);
