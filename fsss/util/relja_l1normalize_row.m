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

function Y= relja_l1normalize_row( X )
    Y= bsxfun(@rdivide, X', sum(abs(X),2)' + 1e-12 )';
end
