function ov = calc_overlap(u,v)
m = size(u,2);

Au = LAF.pt3x3_to_A(u);
Av = LAF.pt3x3_to_A(v);

if ~iscell(Au)
    Au = {Au};
end

if ~iscell(Av)
    Av = {Av};
end

for k = 1:m
    Tu = Au{k}(1:2,3);
    Tv = Av{k}(1:2,3);
    au = Au{k}(1:2,1:2);
    av = Av{k}(1:2,1:2);
    invav = inv(av);
    ov(k) = 0.25*norm(inv(av)*au-eye(2),'fro')^2+norm(inv(av)*(Tu-Tv),2)^2;
end
%
%
%function ov = laf_calc_overlap2d(u,v)
%m = size(u,2);
%n = size(v,2);
%
%Au = LAF.to_A(u);
%Av = LAF.to_A(v);
%
%if ~iscell(Au)
%    Au = {Au};
%end
%
%if ~iscell(Av)
%    Av = {Av};
%end
%
%ov = zeros(m,n);
%
%for i = 1:m
%    for j = i+1:n
%%        if i == j
%%            ov(i,j) = 0;
%%            continue
%%        end
%        Tu = Au{i}(1:2,3);
%        Tv = Av{j}(1:2,3);
%        au = Au{i}(1:2,1:2);
%        av = Av{j}(1:2,1:2);
%        invav = inv(av);
%        ov(i,j) = 0.25*norm(inv(av)*au-eye(2),'fro')^2+norm(inv(av)*(Tu-Tv),2)^2;
%    end
%end
%
%ov = ov'+ov;
