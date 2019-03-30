function cs = label_best_orientation(xu,cspond,l)
[~,side] = PT.are_same_orientation(xu,l);
sides = side(cspond);
[~,best_side] = max(hist(sides(:),[1,2]));
cs = all(sides == best_side);