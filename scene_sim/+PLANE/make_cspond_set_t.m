function [x,cspond,G] = make_cspond_set_t(N,w,h)
x = repmat(LAF.make_random(1),1,N);
t = 0.9*rand(2,N)-0.45;
A = Rt.params_to_mtx([zeros(1,N);t;ones(1,N)]);
x = PT.mtimesx(A,repmat(LAF.make_random(1),1,N));

M = [[w 0; 0 h] [0 0]';0 0 1];
x = reshape(M*reshape(x,3,[]),9,[]);
cspond = transpose(nchoosek(1:N,2));
G = repmat(1,1,N);