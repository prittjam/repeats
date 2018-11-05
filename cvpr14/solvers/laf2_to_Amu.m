function Ha = laf2_to_Amu(u,G,varargin)
cfg = 
cfg = cmp_argparse()

X = cmp_splitapply(@(x) ({x}),u,G);    
Ha = laf2x2_to_Amu_internal(X);   

function A = laf2x2_to_Amu_internal(X)
m = sum(cellfun(@get_size,X));
n = numel(X);
Z = zeros(3*m,3+3*n); 

k = 0;
for j = 1:numel(X)
    u = PT.renormI(X{j});
    v = u([1:2 7:8 1:2],:)-u([4:5 4:5 7:8],:);

    negs = -ones(1,size(v,2));

    k2 = size(v,2);

    Z(k+1:k+k2,[1 2 3 4+3*(j-1)]) = ...
        [v(1,:).^2; ...
         2*v(1,:).*v(2,:); ...
         v(2,:).^2; ...
         negs]';
    k = k+k2;
    Z(k+1:k+k2,[1 2 3 5+3*(j-1)]) = ...
        [v(3,:).^2; ...
         2*v(3,:).*v(4,:); ...
         v(4,:).^2; ...
         negs]';
    k = k+k2;
    Z(k+1:k+k2,[1 2 3 6+3*(j-1)]) = ...
        [v(5,:).^2; ...
         2*v(5,:).*v(6,:); ...
         v(6,:).^2; ...
         negs]';
    k = k+k2;
end

S = diag(1./max(max(abs(Z)),1));
[~,~,V] = svd(Z*S);
V2 = S*V;
%V2 = V;

z = V2(:,end);
z = z/z(1);

if any(z([1,3:end]) < 0)
    A = [];
else
    try
        a = chol([z(1) z(2); z(2) z(3)]);
    catch err
        A = [];
        return;
    end
    A = eye(3,3);
    A(1:2,1:2) = a;
end

function n = get_size(X)
n = size(X,2);
