function [] = draw_affine_csystem(ax1,A,o,color,name)
axes(ax1);
m = size(A,2);
u = A+repmat(o,1,m);
v = 1.1*A+repmat(o,1,m);

hold on;
line([repmat(o(1),1,m);u(1,:)], ...
     [repmat(o(2),1,m);u(2,:)], ...
     [repmat(o(3),1,m);u(3,:)], ...
     'Color', color);
labels = ['xyzw'];

for j = 1:m
    text(v(1,j),v(2,j),v(3,j), ...
         [name '_' labels(j)], ...
         'color', color);
end

hold off;