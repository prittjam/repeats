function draw_3d_ellipse_list(CC,MM)
hold on;
for i=1:size(CC,3)
    draw_3d_ellipse(CC(:,:,i),MM(:,:,i)); 
end
hold off;
end