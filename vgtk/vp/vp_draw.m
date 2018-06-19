function [] = vp_draw()
    v1 = vp_linear(X1);
    v2 = vp_linear(X2);
    
    hold on;
    plot(v1(1),v1(2),'yo');
    plot(v2(1),v2(2),'yo');
    axis([min([1 v1(1)-10 v2(1)-10]) max([size(img,2) v1(1)+10 ...
                        v2(1)+10]) min([1 v1(2)-10 v2(2)-10]) ...
          max([size(img,1) v1(2)+10 v2(2)+10])]);
    hold off;
