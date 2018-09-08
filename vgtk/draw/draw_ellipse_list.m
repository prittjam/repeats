%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function draw_ellipse_list(CC)
hold on;
for i=1:size(CC,3)
    draw_ellipse(CC(:,:,i)); 
end
hold off;
end