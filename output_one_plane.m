%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [rimg,uimg,rect_rd_div_scale_img,rect_dscale_img] = ...
    output_one_plane(img,H,cc,q,v)
[ny,nx,~] = size(img);
[uimg,udtrect,~] = IMG.ru_div(img,cc,q);

figure;
image(udtrect(1),udtrect(2),uimg);
l = transpose(H(3,:));
LINE.draw_extents(gca,l,'LineWidth', 3, ...
                  'Color', 'g', ...
                  'MarkerEdgeColor','w');
axis off;
axis equal;
axis ij;

dims = [ny nx]';
border = IMG.calc_rectification_border(dims,H,cc,q,0.1,10,v);
[rimg,trect,tform] = IMG.ru_div_rectify(img,H,cc,q, ...
                                        'cspond', v, 'border', border, ...
                                        'Registration','Similarity', ...
                                        'Dims',dims);
figure;
subplot(1,3,1);
imshow(img);
subplot(1,3,2);
imshow(uimg);
subplot(1,3,3);
imshow(rimg);

drawnow;

%l = transpose(H(3,:));
%c = LINE.rd_div(l,cc,q);
%[ny,nx,~] = size(img);
%
%border = [0.5        0.5; ...
%          nx-0.5     0.5; ...    
%          nx-0.5     ny-0.5; ...
%          0.5        ny-0.5]; 
%[xx,yy] = CONIC.circrect(border,cc,c);
%
%figure;
%imshow(img);
%hold on;
%CONIC.draw_circle(gca,c, ...
%                  'Xintvl',[xx(1) xx(3)], ...
%                  'Yintvl',[yy(1) yy(3)], ...
%                  'LineWidth', 3, ...
%                  'Color', 'w', ...
%                  'MarkerEdgeColor','w');
%CONIC.draw_circle(gca,c, ...
%                  'Xintvl',[xx(1) xx(3)], ...
%                  'Yintvl',[yy(1) yy(3)], ...
%                  'LineWidth', 2, ...
%                  'Color', 'g');
%hold off;
%
%
%hold on;
%plot(xx(1:2),yy(1:2),'rx');
%hold off;
%
%figure;
%[rect_rd_div_dscale_img,rect_dscale_img,trect] = render_dscale(dims,H,cc,q,v);
%rect_rd_div_dscale_img = 1./rect_rd_div_dscale_img;
%rect_dscale_img  = 1./rect_dscale_img;
%
%minscale = min([rect_rd_div_dscale_img(rect_rd_div_dscale_img > 0); ...
%                rect_dscale_img(rect_dscale_img > 0) ] );
%maxscale = max([rect_rd_div_dscale_img(:); ...
%                rect_dscale_img(:)]);
%
%subplot(1,2,1);
%im1 = image(rect_rd_div_dscale_img, ...
%            'CDataMapping','scaled');
%h = imgca;
%set(h,'Clim',[minscale maxscale]);
%axis equal;
%axis tight;
%
%subplot(1,2,2);
%im2 = image(trect(1:2),trect(3:4),rect_dscale_img, ...
%            'CDataMapping','scaled');
%h = imgca;
%set(h,'Clim',[minscale maxscale]);
%axis equal;
%axis tight;
%
%
%
