%
% Author:
% 
% Relja Arandjelovic (relja@robots.ox.ac.uk)
% Visual Geometry Group,
% Department of Engineering Science
% University of Oxford
% 
% Copyright 2014, all rights reserved.
% 

function hsv= relja_rgb2hsv( im )
    if size(im,3)==1
        im= cat(3, im,im,im);
    end
    hsv= rgb2hsv( im );
end
