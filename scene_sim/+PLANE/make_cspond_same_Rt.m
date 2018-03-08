function X = make_cspond_same_Rt(N,w,h)
x = repmat(LAF.make_random(1),1,N);
t = 0.9*rand(2,N)-0.45;
x1 = LAF.translate(x,t);
x2 = do_rigid_xform(x1);
x = reshape([x1;x2],9,[]);
M = [[w 0; 0 h] [0 0]';0 0 1];
M2 = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(M2*M*reshape(x,3,[]),12,[]);

function x2 = do_rigid_xform(x1)
N = size(x1,2);
theta = repmat(2*pi*rand(1),1,size(x1,2));
n = [cos(theta);sin(theta)];
a = [(-0.5-x1(4,:))./n(1,:);
     (0.5-x1(4,:))./n(1,:); ...
     (-0.5-x1(5,:))./n(2,:);
     (0.5-x1(5,:))./n(2,:)];
[as,ind] = sort(a,1);
l = max(as(2,:));
u = min(as(3,:));
x2 = zeros(size(x1));
t = (u-l)*(0.9*rand(1)+0.1);
for k = 1:N
    Rt = [2*pi*rand(1);bsxfun(@times,t,n(:,k));1];
    x2(:,k) = LAF.apply_rigid_xforms(x1(:,k),Rt);
end
