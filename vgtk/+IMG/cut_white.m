%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [nimg, T, dim] = cut_white(img)
T = eye(3);
simg = sum(img,3);

mask = sum(simg,1) ~= 765*size(simg,1);
first1 = find(mask,1,'first');
last1 = find(mask,1,'last');
nimg = img(:,first1:last1,:);
if ~isempty(first1)
	T(1,3) = -first1+1;
end

mask = sum(simg,2) ~= 765*size(simg,2);
first2 = find(mask,1,'first');
last2 = find(mask,1,'last');
nimg = nimg(first2:last2,:,:);
if ~isempty(first2)
	T(2,3) = -first2+1;
end

dim = [first2 last2 first1 last1];


