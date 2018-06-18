function draw_ellipse_list(CC)
hold on;
for i=1:size(CC,3)
    draw_ellipse(CC(:,:,i)); 
end
hold off;
end