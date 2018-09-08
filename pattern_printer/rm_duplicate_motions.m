%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function w = rm_duplicate_motions(K,w)
for k = 1:numel(w)
    w1 = w;
    w1(k) = 0;
    b = K*w1; 
    if all(b > 1e-5)
        w = w1;
    end
end

