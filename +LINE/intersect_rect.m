%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
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


%function res = intersect_rect(l,v)
%if isempty(v)
%    v = axis;
%end
%
%c = [mean([v(1) v(2)]); mean([v(3) v(4)])];
%
%n = size(l,2);
%
%top = repmat(cross([v(1) v(3) 1]',[v(2) v(3) 1]'),1,n);
%bottom = repmat(cross([v(1) v(4) 1]',[v(2) v(4) 1]'),1,n);
%left = repmat(cross([v(1) v(3) 1]',[v(1) v(4) 1]'),1,n);
%right = repmat(cross([v(2) v(3) 1]',[v(2) v(4) 1]'),1,n);
%
%pts = [PT.renormI(cross(l,top,1)); 
%       PT.renormI(cross(l,bottom,1));  ...
%       PT.renormI(cross(l,left,1)); 
%       PT.renormI(cross(l,right,1))];
%
%pts = reshape(pts([1 2 4 5 7 8 10 11],:),2,[]);
%r = reshape(sqrt(sum(bsxfun(@minus,pts,c).^2)),4,[]);
%
%[~,I] = sort(r,1);
%I = I+[0:4:4*(size(l,2)-1)];
%
%res = struct('x',mat2cell([pts(:,I(1:2,:));ones(1,2*size(l,2))],3, ...
%                          2*ones(1,size(l,2))));
%
%keyboard;
