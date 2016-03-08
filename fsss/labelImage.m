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

function outlabel= labelImage(labels, w, h, resw, resh, isStanfordBg)
    if nargin==3, resw= w; resh= h; origSize=true; else
        origSize= resw==w && resh~=h;
    end
    if nargin<6, isStanfordBg= false; end
    
    if ~isStanfordBg
        newColours= uint8([128 128 128; 255 0 0; 0 255 0; 0 0 255]);
    else
        newColours= uint8(round( 255*colorcube(8+1) ));
    end
    
    outlabel= reshape( newColours( labels+1, : ), [h, w, 3] );
    if ~origSize
        outlabel= imresize( outlabel, [resh, resw], 'nearest' );
    end
end
