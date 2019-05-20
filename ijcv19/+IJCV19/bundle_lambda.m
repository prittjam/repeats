function [] = bundle_lambda(x,X,lambda,K,Rt,max_iters,sz)
pp = [sz(2)/1 sz(1)/2];
K(1:2,3) = pp;

n_cams = numel(x);
dz0 = zeros(6*n_cams+2,1);

[dz,resnorm,err] = lsqnonlin(compute_res,this.dz0);

update_vars(dz,lambda,K,Rt)

function [lambda,K,Rt] = update_vars(dp,lambda,K,Rt)
lambda = lambda + dp(1);
K = K + [dp(2) 0    0; ...
         0    dp(2) 0; ...
         0     0    0];
n_cams = (length(dp)-2)/6;
for i = 1:n_cams
    Rt{i}(:,1:3) =  expm(dp(2+3*i-2)*S1 + dp(2+3*i-1)*S2 + dp(2+3*i)*S3)*Rt{i}(:,1:3);
    Rt{i}(:,4) =  Rt{i}(:,4) + dp(2+3*(i+n_cams)-2:2+3*(i+n_cams));
end

function res = compute_res(x,X,lambda0,K0,Rt0)
[lambda,K,Rt] = update_vars(dz,lambda0,K0,Rt0);
count = 1;
for f = 1:length(x)
    R = Rt{f}(:,1:3);
    t = Rt{f}(:,4);
    n = size(x{f},2);
    for k = 1:n
        Z = R*X{f}(1:3,k)+t;
        z = Z(1:2)/Z(3);        
        r2 = z'*z;
        alpha_sqrt = sqrt(1/(4*lambda^2*r2^2) - 1/(lambda*r2));
        alpha = 1/(2*lambda*r2) - sign(lambda)*alpha_sqrt;
        res(count:count+1,1) = K(1:2,:)*[z*alpha;1] - x{f}(1:2,k);
        count = count + 2;
    end
end