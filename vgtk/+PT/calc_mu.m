%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function mux = calc_mu(x)
n = size(x,1)/3;
mux = squeeze(mean(reshape(x,3,n,[]),2));