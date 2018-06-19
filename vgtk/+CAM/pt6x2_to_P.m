function [opt_Q,err_points] = cam_est_P_6p(u,s)
ib = find(s);
m = numel(ib);

M = [u(1:4,s)                         zeros(4,m); ... ...
     zeros(4,m)                       u(1:4,s); ...                  
    -bsxfun(@times,u(1:4,s),u(5,s))  -bsxfun(@times,u(1:4,s),u(6,s))];

C = nchoosek([1:12],11);

for i = 1:size(C,1)
    [u,d,v] = svd(M(:,C(i,:))');
    QQ{i} = reshape(v(:,end),4,3)';
end

err_max = inf;
for j = 1:length(QQ)
    Q = QQ{j};
    x2 = renormI(Q{k}*u(1:4,:));
    d = sqrt(sum((x2(1:2,:)-u(5:6)).^2));
    d_max = max(d);
    err_max_list(k) = d_max;
    if d_max < err_max
        err_max = d_max
        opt_Q = Q;
        err_points = d;
    end
end