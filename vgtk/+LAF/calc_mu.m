%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function mux = calc_mu(x)
mux = [(x(1:2,:)+x(4:5,:)+x(7:8,:))/3];
