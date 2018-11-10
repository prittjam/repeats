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
    Rt(2:3,:) = [ -a11.*c.*Rt(2,:)-s.*Rt(3,:); ...
                  a11.*s.*Rt(2,:)-c.*Rt(3,:) ]; 

    
%     syms a11 c s tx ty
%    R = [a11 0; 0 1]*[c -s; s c];
%    A = [ R transpose([tx ty]);0 0 1];
%A=    subs(A,c^2,1-s^2)
%    A= simplify(A)
%    invA = simplify(inv(A))
%    invA = simplify(subs(invA,c^2,1-s^2))