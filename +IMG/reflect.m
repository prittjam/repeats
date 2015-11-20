function rimg = reflect(img,varargin)
rimg = img(:,end:-1:1,:);