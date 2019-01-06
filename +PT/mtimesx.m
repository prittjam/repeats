function xp = mtimesx(M,x)
xp = zeros(size(x));  
m = size(x,1);
for k = 1:3:m
    xp(k:k+2,:) = mtimesx(M,reshape(x(k:k+2,:),3,1,[]));
end