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

function Y= relja_l1normalize_col( X )
    Y= bsxfun(@rdivide, X, sum(abs(X),1) + 1e-12 );
end
