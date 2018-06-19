function [x,y] = p3x3_to_xy(u)
x = reshape(u([1 4 7],:),1,[]);
y = reshape(u([2 5 8],:),1,[]);