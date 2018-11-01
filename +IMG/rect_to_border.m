function border = rect_to_boundary(rect)
aa = linspace(rect(1),rect(3),20);
bb = linspace(rect(2),rect(4),20);
[xx,yy] = ndgrid(aa,bb);
ind = boundary(xx(:),yy(:));
xx = xx(ind);
yy = yy(ind);
border = [xx yy];