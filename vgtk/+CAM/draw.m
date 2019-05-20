%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = draw(ax,P)
s = 10;
[K R c] = CAM.P_to_KRc(P);
sR = s*R;
hold on;
plot3(c(1),c(2),c(3),'go');
color_list = [1 0 0; 0 1 0; 0 0 1];
for k = 1:3
    line([c(1) c(1)+sR(1,k)], ...
         [c(2) c(2)+sR(2,k)], ...
         [c(3) c(3)+sR(3,k)], ...
         'Color',color_list(k,:));
end
hold off;
