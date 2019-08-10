function [X,cspond,G] = make_cspond_set_t(N,w,h,reflect)
if nargin < 4
    reflect = 0
end

x = repmat(LAF.make_random(1),1,N);
t = 0.9*rand(2,N)-0.45;

r = double(rand(1,N) > reflect);
r(r==0) = -1;

A = Rt.params_to_mtx([zeros(1,N);t;r]);
x = PT.mtimesx(A,repmat(LAF.make_random(1),1,N));


M = [[w 0; 0 h] [0 0]';0 0 1];
M2 = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(M2*M*reshape(x,3,[]),12,[]);
cspond = transpose(nchoosek(1:N,2));
G = repmat(1,1,N);
