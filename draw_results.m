%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function h = draw_results(img,rimg,ud_img)
figure;
if nargin == 2
    h = zeros(1,2);
    h(1) = subplot(1,2,1);
    imshow(img.data);
    h(2) = subplot(1,2,2);
    imshow(rimg);
elseif nargin == 3
    h(1) = subplot(1,3,1);
    imshow(img.data);
    h(2) = subplot(1,3,2);
    imshow(rimg);
    h(3) = subplot(1,3,3);
    imshow(ud_img);
end
