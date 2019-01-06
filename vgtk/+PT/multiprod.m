function y = multiprod(T,x)
m = size(x,1);
y = reshape(multiprod(T,reshape(x,3,[])),m,[]);