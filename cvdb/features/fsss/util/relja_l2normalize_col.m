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

function Y= relja_l2normalize_col( X )
    Y= bsxfun(@rdivide, X, sqrt(sum(X.^2,1)) + 1e-12 );
end
