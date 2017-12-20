function L = mtx_chol_2x2(M)
k = numel(M);
A = cell2mat(M);
L = zeros(2,2,k);

L(1,1,:) = sqrt(A(1,1,:));
L(2,1,:) = A(2,1,:)./L(1,1,:);
L(2,2,:) = sqrt(A(2,2,:)-L(2,1,:).^2);

L = mat2cell(L);