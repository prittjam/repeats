clear
rng(12345)

err_lambda = [];
err_line = [];

for iter = 1:1000
    
    fgt = 1000;

    lambda_gt = -0.4*rand /fgt^2;
    lgt = randn(2,1) / fgt;

    x1 = fgt*randn(2,3);
    x2 = fgt*randn(2,3);
    c1 = 1 + 0.1*randn(1,3);
    c2 = 1 + 0.1*randn(1,3);

    s1 = 1+10*rand(1,3);

    d1 = sum(x1.^2);
    d2 = sum(x2.^2);

    sgt = s1 .* (c1-lambda_gt*d1)./(c1+lgt'*x1 + lambda_gt*d1).^3;
    
    % Choose s2 to satisfy equations
    s2 = sgt ./ ((c2-lambda_gt*d2)./(c2+lgt'*x2 + lambda_gt*d2).^3);

%     % sanity check
%     ss1 = s1 .* (c1-lambda_gt*d1)./(c1 + lgt'*x1 + lambda_gt*d1).^3;
%     ss2 = s2 .* (c2-lambda_gt*d2)./(c2 + lgt'*x2 + lambda_gt*d2).^3;
%     res_gt = norm(ss1-ss2);
    
      
    % Call solver
    tic
    [lambda, l] = solver_rect_cos_222(x1,s1,c1,x2,s2,c2);
    toc
    
    if isempty(lambda)
        err_lambda(iter) = inf;
        err_line(iter) = inf;
    else
        err_lambda(iter) = min(abs(lambda-lambda_gt))*fgt^2;
        err_line(iter) = min(sqrt(sum((lgt*ones(1,length(lambda))-l).^2)));
    end
end

hist(log10([err_lambda; err_line]'))
legend('lambda','line')


%% Runtime


% Rescale the scale
scale_scale = (abs(s1)+abs(s2))/2;
s1 = s1 ./ scale_scale;
s2 = s2 ./ scale_scale;

data = [x1 x2];
d = sum(data(1:2,:).^2);

% Rescale line and lambda unknowns
scale_line = mean(abs(data(1:2,:)),2);
scale_lambda = mean(d);

data(1:2,:) = diag(1./scale_line)*data(1:2,:);
data = [data; s1 s2; c1 c2; d / scale_lambda];

data0 = [];
for k = 1:1000
    data0 = [data0 data];
end

tic
sols = solver_rect_cos_222_bs_mex(data0);
toc

sols = real(sols(:,max(abs(imag(sols)))<1e-6));

lambda = sols(1,:) / scale_lambda;
l = diag(1./scale_line) * sols(2:3,:);


%%

tic
for k = 1:1000
%     [lambda, l] = solver_rect_cos_222(x1,s1,c1,x2,s2,c2);
sols = solver_rect_cos_222_bs_fast_mex(data);

end
toc
