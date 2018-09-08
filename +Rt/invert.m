%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function Rt = invert(Rt)
    c = cos(Rt(1,:));
    s = sin(Rt(1,:));

    a11 = Rt(4,:);
    is_reflected =  a11 == -1;
    
    Rt(1,~is_reflected) = -Rt(1,~is_reflected);
    
    Rt(2:3,:) = [ -a11.*(c.*Rt(2,:)+s.*Rt(3,:)); ...
                  s.*Rt(2,:)-c.*Rt(3,:) ]; 
