function [rimg,uimg] = output_one_plane(img,H,cc,q,v)
[ny,nx,~] = size(img);
[uimg,~,trect] = IMG.ru_div(img,cc,q);

rimg = render_rectification(img,H,cc,q,v, ...
                            'MinScale', 0.1, ...
                            'MaxScale', 10);

figure;
subplot(1,3,1);
imshow(img);
subplot(1,3,2);
imshow(uimg);
subplot(1,3,3);
imshow(rimg);

figure;
dims = [ny nx];
[rect_rd_div_dscale_img,rect_dscale_img,trect] = render_dscale(dims,H,cc,q,v);
rect_rd_div_dscale_img = 1./rect_rd_div_dscale_img;
rect_dscale_img  = 1./rect_dscale_img;

minscale = min([rect_rd_div_dscale_img(rect_rd_div_dscale_img > 0); ...
                rect_dscale_img(rect_dscale_img > 0) ] );
maxscale = max([rect_rd_div_dscale_img(:); ...
                rect_dscale_img(:)]);

subplot(1,2,1);
im1 = image(rect_rd_div_dscale_img, ...
            'CDataMapping','scaled');
h = imgca;
set(h,'Clim',[minscale maxscale]);
axis equal;
axis tight;

subplot(1,2,2);
im2 = image(trect(1:2),trect(3:4),rect_dscale_img, ...
            'CDataMapping','scaled');
h = imgca;
set(h,'Clim',[minscale maxscale]);
axis equal;
axis tight;

l = transpose(H(3,:));
c = CAM.rd_div_line(l,cc,q);
[ny,nx,~] = size(img);

border = [0.5        0.5; ...
          nx-0.5     0.5; ...    
          nx-0.5     ny-0.5; ...
          0.5        ny-0.5]; 
[xx,yy] = CAM.rectcirc(border,cc,c);

figure;
subplot(1,2,1);
imshow(img);
CONIC.draw_circle(gca,c, ...
                  'xintvl', [xx(3:4)], ...
                  'yintvl', [yy(3:4)], ...
                  'LineWidth', 3, ...
                  'Color', 'w', ...
                  'MarkerEdgeColor','w');

CONIC.draw_circle(gca,c, ...
                  'xintvl', [xx(3:4)], ...
                  'yintvl', [yy(3:4)], ...
                  'LineWidth', 2, ...
                  'Color', 'g');

hold on;
plot(xx(1:2),yy(1:2),'rx');
hold off;

subplot(1,2,2);
image(trect(1:2),trect(3:4),uimg);
axis off 
LINE.draw_extents(gca,l,'Color','w', ...
                  'LineWidth', 3, ...
                  'Color', 'w', ...
                  'MarkerEdgeColor','w');
LINE.draw_extents(gca,l,'Color','g', ...
                  'LineWidth', 2);
axis equal;