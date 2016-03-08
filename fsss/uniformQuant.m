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

function q= uniformQuant(x, k)
    q= min(max(ceil(x*k),1),k);
end
