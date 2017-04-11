function Rt = laf2xN_to_RtxN(u)
M = size(u,2);
theta = zeros(3,M);

u_ii = u(1:9,:);
mu_ii = (u_ii(1:2,:)+u_ii(4:5,:)+u_ii(7:8,:))/3;

u_jj = u(10:18,:);
mu_jj = (u_jj(1:2,:)+u_jj(4:5,:)+u_jj(7:8,:))/3;

for k = 1:3
    k2 = 3*(k-1);
    v_ii = u_ii([1 2]+k2,:)-mu_ii;
    v_ii = bsxfun(@rdivide,v_ii,sqrt(sum(v_ii.^2)));
    v_jj = u_jj([1 2]+k2,:)-mu_jj;
    v_jj = bsxfun(@rdivide,v_jj,sqrt(sum(v_jj.^2)));        
    theta(k,:) = mod(atan2(v_ii(1,:).*v_jj(2,:)-v_jj(1,:).*v_ii(2,:), ...
                           v_ii(1,:).*v_jj(1,:)+v_ii(2,:).*v_jj(2,:)),2*pi);
end

theta = atan2(mean(sin(theta)),mean(cos(theta)));

c = cos(theta);
s = sin(theta);
t = mu_jj-[c.*mu_ii(1,:)-s.*mu_ii(2,:); ...
           s.*mu_ii(1,:)+c.*mu_ii(2,:)];
Rt = [theta;t];
