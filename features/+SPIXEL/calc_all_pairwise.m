function D = calc_all_pairwise(img,segments)
[R indnz] = SPIXEL.calc_pairwise(img,segments);
A = R;
A(indnz) = 1 - A(indnz) + eps;
[D,P] = floyd_warshall_all_sp(sparse(A));
n = size(R,1);
for i = 1:n
	for j = 1:n
		if i ~= j
			p=[]; 
			k = j;
			while k~=0, p(end+1)=k; k =P(i,k); end; 
			p=fliplr(p);
			ind = p([1:(numel(p)-1); 2:numel(p)]');
			ind = n*(ind(:,1) - 1) + ind(:,2);
			D(i,j) = 1 - min(R(ind));
		end
	end
end
