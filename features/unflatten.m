%
%  Copyright (c) 2018 James Pritts, Denys Rozumnyi, CTU in Prague
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts and Denys Rozumnyi
%
function dr = unflatten(fdr)
str = fieldnames(dr);

for k = str'
    fdr.(k{:}) = [dr(:).(k{:})];
end

fdr.num_dr = size(fdr.desc,2);