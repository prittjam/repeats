%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function Y = renormI(X)
    Y = bsxfun(@rdivide,X,X(end,:));
