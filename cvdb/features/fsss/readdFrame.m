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

function imout= readdFrame(imout, frameinfo)
    if frameinfo.hasFrame
        x1= frameinfo.roi(1);
        x2= frameinfo.roi(2);
        y1= frameinfo.roi(3);
        y2= frameinfo.roi(4);
        
        imout= [ones(y1, frameinfo.origW); ...
                ones(size(imout,1), x1), imout, ones(size(imout,1), frameinfo.origW-x2+1); ...
                ones(frameinfo.origH-y2+1, frameinfo.origW) ];
    end
end
