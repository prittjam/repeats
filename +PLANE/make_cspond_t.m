function [X,G,border] = make_cspond_t(num_groups,num_cspond,w,h)
x = LAF.make_random(num_groups);
t = 0.9*rand(2,num_groups)-0.45;
x1 = LAF.translate(x,t);
theta = 2*pi*rand(1,num_groups);
n = [cos(theta);sin(theta)];
a = [(-0.5-x1(4,:))./n(1,:);
     (0.5-x1(4,:))./n(1,:); ...
     (-0.5-x1(5,:))./n(2,:);
     (0.5-x1(5,:))./n(2,:)];

[~,ind] = sort(abs(a),1);

x2 = zeros(size(x));
for k = 1:num_groups
    l = min(a(ind(1:2),k));
    u = max(a(ind(1:2),k));
    t = (u-l)*rand(1)+l;
    x2(:,k) = LAF.translate(x1(:,k),t*n(:,k));
end

x = reshape([x1;x2],9,[]);

figure;
LAF.draw(gca,x);


%M = [[w 0; 0 h] [0 0]';0 0 1];
%xp2 = blkdiag(M,M,M)*xp;
%
%
%M2 = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
%X = reshape([1 0 0; 0 1 0; 0 0 0; 0 0 1]*reshape(xp2,3,[]),12,[]);
%G = reshape(repmat([1:num_groups],num_cspond,1),1,[]);
%
%border = M2*M*[-0.5 0.5  0.5 -0.5  -0.5; ...
%               -0.5 -0.5 0.5  0.5  -0.5; ...
%                  1   1  1  1      1];
