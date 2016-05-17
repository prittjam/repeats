function Ha = laf1x1_to_A(v,s,varargin)
if nargin < 2
    s = true(1,size(v,2));
end

v = v(:,s);
m = size(v,2);
if m == 1
    Ha =  LAF.p3x3_to_A(v(10:18,:))*inv(LAF.p3x3_to_A(v(1:9,:)));
else
    u = reshape(v([1:2 10:11 4:5 13:14 7:8 16:17],:),4,[]);    
    s = true(1,size(u,2));
    Ha = HG.p3_to_A(u);
end