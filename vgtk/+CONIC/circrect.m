%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [xx,yy] = circrect(border,cc,c)
m = nan(1,4);
b = nan(1,4);

m = transpose((border([2:4 1],2)-border(1:4,2))./(border([2:4 1],1)-border(1:4,1)));
b(isinf(m)) = border(isinf(m),1);
b(~isinf(m)) = border(~isinf(m),2);
xx = zeros(1,8); 
yy = zeros(1,8); 
for k = 1:4 
    [xx(2*(k-1)+1:2*k),yy(2*(k-1)+1:2*k)]= ...
        linecirc(m(k),b(k),c(1),c(2),c(3));  
end
d2 = sum(bsxfun(@minus,[xx;yy],cc).^2);
[~,ind] = sort(d2);
xx = xx(ind);
yy = yy(ind);


keyboard;

function [x,y]=linecirc(slope,intercpt,centerx,centery,radius) 
 
%LINECIRC  Find the intersections of a circle and a line in cartesian space 
% 
%  [xout,yout] = LINECIRC(slope,intercpt,centerx,centery,radius) finds 
%  the points of intersection given a circle defined by a center and 
%  radius in x-y coordinates, and a line defined by slope and 
%  y-intercept, or a slope of "inf" and an x-intercept.  Two points 
%  are returned.  When the objects do not intersect, NaNs are returned. 
%  When the line is tangent to the circle, two identical points are 
%  returned. All inputs must be scalars 
% 
%  See also CIRCCIRC 
 
%  Copyright 1996-2002 Systems Planning and Analysis, Inc. and The MathWorks, Inc. 
%  Written by:  E. Brown, E. Byrns 
%   $Revision: 1.9 $    $Date: 2002/03/20 21:25:45 $ 
 
 
if nargin ~= 5;  error('Incorrect number of arguments');  end 
 
%  Input consistency test 
 
if ~isequal(size(slope),size(intercpt),size(centerx),size(centery),size(radius),[1,1]) 
	     error('Inputs must be scalars') 
elseif ~isreal([slope intercpt centerx centery radius]) 
		error('inputs must be real') 
elseif radius<=0 
		error('radius must be positive') 
end 
 
 
% find the cases of infinite slope and handle them separately 
 
if ~isinf(slope) 
	% From the law of cosines 
 
	a=1+slope.^2; 
	b=2*(slope.*(intercpt-centery)-centerx); 
	c=centery.^2+centerx.^2+intercpt.^2-2*centery.*intercpt-radius.^2; 
 
	x=roots([a,b,c])'; 
 
	%  Make NaN's if they don't intersect. 
 
	if ~isreal(x) 
		x=[NaN NaN]; y=[NaN NaN]; 
	else 
		y=[intercpt intercpt]+[slope slope].*x; 
	end 
 
% vertical slope case 
elseif abs(centerx-intercpt)>radius  % They don't intercept 
	x=[NaN;NaN]; y=[NaN;NaN]; 
else 
	x=[intercpt intercpt]; 
	step=sqrt(radius^2-(intercpt-centerx)^2); 
	y=centery+[step,-step]; 
end 
