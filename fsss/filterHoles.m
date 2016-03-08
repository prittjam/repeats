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

function labels= filterHoles(labels)
    % thrAbs= 25000;
    thrRel= 0.04;
    
    other= labels==1;
    filled= imfill(other,'holes');
    p= regionprops( bwlabel(~other & filled), 'PixelIdxList', 'Area' );
    % keep= cat(1,p.Area) < thrAbs;
    keep= (cat(1,p.Area) / numel(other)) < thrRel;
    p= p(keep);
    other( cat(1,p.PixelIdxList) )= true;

%      subplot(1,2,1); imshow(labelImage(labels,size(labels,2),size(labels,1)));
    labels(other)= 1;
%      subplot(1,2,2); imshow(labelImage(labels,size(labels,2),size(labels,1)));
end

