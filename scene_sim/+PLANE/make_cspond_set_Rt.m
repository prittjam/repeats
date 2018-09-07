function [X,cspond,G] = make_cspond_set_Rt(N)
theta = 2*pi*rand(1,N);
t = 0.9*rand(2,N)-0.45;
r = ones(1,N);
%r = double(rand(1,N) > 0.5);
%r(r==0) = -1;
x = LAF.apply_rigid_xforms(repmat(LAF.make_random(1),1,N), ...
                           [theta;t;r]);
M = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(M*reshape(x,3,[]),12,[]);
cspond = transpose(nchoosek(1:N,2));
G = repmat(1,1,size(X,2));
