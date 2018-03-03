function [nimg, T, dim] = cut_black(img)
T = eye(3);
simg = sum(img,3);

mask = sum(simg,1);
first1 = find(mask,1,'first');
last1 = find(mask,1,'last');
nimg = img(:,first1:last1,:);
T(1,3) = -first1+1;

mask = sum(simg,2);
first2 = find(mask,1,'first');
last2 = find(mask,1,'last');
nimg = nimg(first2:last2,:,:);
T(2,3) = -first2+1;

dim = [first2 last2 first1 last1];