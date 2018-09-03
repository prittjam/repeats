function [X,cspond,G] = make_cspond_set_t(N,w,h)
x = repmat(LAF.make_random(1),1,N);
t = 0.9*rand(2,N)-0.45;
x = LAF.translate(x,t);
M = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(M*reshape(x,3,[]),12,[]);
cspond = transpose(nchoosek(1:N,2));
G = repmat(1,1,N);
