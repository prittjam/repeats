function u = shrink(u,displacement)
dist = u([1 2 7 8],:) - u([4 5 4 5],:);
adist = abs(dist);
h = hypot(adist([1 3],:),adist([2 4],:));
movex = adist([1 3],:)./h;
movey = adist([2 4],:)./h;
if displacement < 1
	len1 = sqrt(dist(1,:).^2 + dist(2,:).^2);
	len2 = sqrt(dist(3,:).^2 + dist(4,:).^2);
	u([1 7],:) = u([1 7],:) - sign(dist([1 3],:)).*[len1; len2].*displacement.*movex;
	u([2 8],:) = u([2 8],:) - sign(dist([2 4],:)).*[len1; len2].*displacement.*movey;
else
	u([1 7],:) = u([1 7],:) - sign(dist([1 3],:)).*displacement.*movex;
	u([2 8],:) = u([2 8],:) - sign(dist([2 4],:)).*displacement.*movey;
end