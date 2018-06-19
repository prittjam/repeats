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

% inverse a rotation specified by exif (e.g. if I processed a rotated image and want to return it back to the original orientation)

function im= relja_imreadExifInvRot(fn, im)
    exifInfo= imfinfo(fn);
    if ~ismember('Orientation', fieldnames(exifInfo))
        return;
    end
    switch exifInfo.Orientation
        case 0
            return;
        case 1
            return;
        case 2
            im= im(:,end:-1:1,:);
            return;
        case 3
            im= im(:,end:-1:1,:);
            im= relja_imrot90(im,2);
            return;
        case 4
            im= im(:,end:-1:1,:);
            return;
        case 5
            im= relja_imrot90(im,1);
            im= im(:,end:-1:1,:);
            return;
        case 6
            im= relja_imrot90(im,1);
            return;
        case 8
            im= relja_imrot90(im,3);
            return;
        case 7
            im= im(:,end:-1:1,:);
            im= relja_imrot90(im,3);
            return;
    end
    error( sprintf('Unrecognized orientation %d for image %s', exifInfo.Orientation, fn ) );
end
