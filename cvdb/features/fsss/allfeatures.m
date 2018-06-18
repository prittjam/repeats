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

function [imHSV, frames, rsifts]= allfeatures(im, sizes)
    imHSV= reshape( relja_hsv(im), [], 3 );
    if nargin<2
        [frames,rsifts]= vl_phow( im2single(rgb2gray(im)) );
    else
        assert(~isempty(sizes)); % you forgot to update the call
        [frames,rsifts]= vl_phow( im2single(rgb2gray(im)), 'Sizes', sizes );
    end
    rsifts= single(rsifts);
    rsifts= relja_l2normalize_col( sqrt(rsifts) );
    
    imHSV= single(imHSV);
    rsifts= single(rsifts);
end
