%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function err = geman_mcclure(err,sigma)
err = sqrt(err.^2./(sigma^2+err.^2));
