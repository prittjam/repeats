%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function s = calc_scale(x)
m = size(x,1);
x = PT.renormI(x);
if m == 6
    mux = PT.calc_mu(x);
    s = pi*sum((mux-x(1:3,:)).^2);
elseif m == 9
    lafsA1 = x(1,:);
    lafsA2 = x(2,:);
    lafsB1 = x(4,:);
    lafsB2 = x(5,:);
    lafsC1 = x(7,:);
    lafsC2 = x(8,:);
    
    s = ((lafsA1-lafsB1).*(lafsA2+lafsB2) + ...
         (lafsB1-lafsC1).*(lafsB2+lafsC2) + ...
         (lafsC1-lafsA1).*(lafsC2+lafsA2))/2;
end