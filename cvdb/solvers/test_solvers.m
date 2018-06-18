%% {1,2,3},{4,5} case

clear
rng(12345)

res_all = [];
t = [];
for iter = 1:100
    
    x11 = randn(2,3);
    x12 = randn(2,3);
    x13 = randn(2,3);
    x21 = randn(2,3);
    x22 = randn(2,3);
    x = {x11,x12,x13,x21,x22};
    
    tic
    [lambda,ll] = solver_changeofscale_32_new_basis_d2(x11,x12,x13,x21,x22,0);
    t(iter) = toc;
    
    s = compute_scales(lambda,ll,x);
    
    % relative error
    ms = [mean(s(:,[1 2 3]),2) mean(s(:,[4 5]),2)];
    res = abs(s(:,[1 2 4])-s(:,[2 3 5])) ./ abs(ms(:,[1 1 2]));
    res = log10(max(res,[],2));
    res_all = [res_all; res];
end


quantile(res_all,[0.25 0.5 0.75])
median(t)*1000

%% {1,2,3,4} case

clear
rng(12345)
res_all = [];
t = [];
for iter = 1:100
    
    x11 = randn(2,3);
    x12 = randn(2,3);
    x13 = randn(2,3);
    x14 = randn(2,3);
    
    x = {x11,x12,x13,x14};
    
    tic
    [lambda,ll] = solver_changeofscale_4_new_basis_d2(x11,x12,x13,x14,0);
    t(iter) = toc;
    
    s = compute_scales(lambda,ll,x);
    
    % relative error
    ms = mean(s,2);
    res = abs(s(:,[1 2 3])-s(:,[4 4 4])) ./ abs(ms(:,[1 1 1]));
    res = log10(max(res,[],2));
    res_all = [res_all; res];
end


quantile(res_all,[0.25 0.5 0.75])
median(t)*1000


%% {1,2},{3,4},{5,6} case

clear
rng(12345)
res_all = [];
t = [];
for iter = 1:100
    
    x11 = randn(2,3);
    x12 = randn(2,3);
    x21 = randn(2,3);
    x22 = randn(2,3);
    x31 = randn(2,3);
    x32 = randn(2,3);
    
    x = {x11,x12,x21,x22,x31,x32};
    
    tic
    [lambda,ll] = solver_changeofscale_222_new_basis_d2(x11,x12,x21,x22,x31,x32,0);
%     [lambda,ll] = solver_changeofscale_222_new_basis_d2_old(x11,x12,x21,x22,x31,x32,0);
    t(iter) = toc;
    
    s = compute_scales(lambda,ll,x);
    
    % relative error
    ms = (s(:,[1 3 5])+s(:,[2 4 6]))/2;
    res = abs(s(:,[1 3 5])-s(:,[2 4 6])) ./ abs(ms);
    res = log10(max(res,[],2));
    res_all = [res_all; res];
end


quantile(res_all,[0.25 0.5 0.75])
median(t)*1000




