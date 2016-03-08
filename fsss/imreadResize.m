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

function [imRGB, origH, origW, frameinfo]= imreadResize(fn, doRemoveFrame)
    if nargin<2, doRemoveFrame= true; end
    imRGB= im2single( relja_imreadExifRot(fn) );
    if doRemoveFrame
        [imRGB, frameinfo]= removeFrame(imRGB);
    else
        frameinfo= struct();
        frameinfo.origH= size(imRGB,1);
        frameinfo.origW= size(imRGB,2);
        frameinfo.hasFrame= false;
    end
    
    origH= size(imRGB,1); origW= size(imRGB,2);
    scalefact= min( 500./[origH, origW] );
    if (scalefact<0.99), imRGB= imresize(imRGB, scalefact); end
    imRGB= min( max(imRGB, 0), 1); % imresize can violate the [0,1] range which in turn messes up rgb2hsv
end
