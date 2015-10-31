function [nimg, T] = cut_white(img)
T = eye(3);
simg = sum(img,3);
mask = sum(simg,1) ~= 765*size(simg,1);
nimg = img(:,find(mask,1,'first'):find(mask,1,'last'),:);
T(1,3) = -find(mask,1,'first');
mask = sum(simg,2) ~= 765*size(simg,2);
nimg = nimg(find(mask,1,'first'):find(mask,1,'last'),:,:);
T(2,3) = -find(mask,1,'first');