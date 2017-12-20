function v = pt2x3_to_pt3x3(u)
v = ones(9,size(u,2));
v([1 2 4 5 7 8],:) = u;