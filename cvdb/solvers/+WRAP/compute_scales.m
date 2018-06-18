function scales = compute_scales(lambda,l,x)

scales = zeros(length(lambda),length(x));

d = cellfun(@(x) sum(x.^2),x,'UniformOutput',0);

for i = 1:length(lambda)
    for j = 1:length(x)

        a = l(:,i)' * [x{j}; 1+lambda(i)*d{j}];
        xp = [x{j}; a];
        
        scales(i,j) = det(xp) / prod(a);

    end
end

end

