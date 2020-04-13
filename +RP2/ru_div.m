%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function xu = ru_div(xd, cc, q)
    m = size(xd, 1);
    xu = reshape(CAM.ru_div(reshape(xd, 3, []), cc, q), m, []);
end