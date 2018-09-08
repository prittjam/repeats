%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function c = eg_make_cubic_constraint(file_name)
syms a ...
     F11 F21 F31 F41 F51 F61 F71 F81 F91 ...
     F12 F22 F32 F42 F52 F62 F72 F82 F92;

F1 =  [ F11 F41 F71; ...
        F21 F51 F81; ...
        F31 F61 F91 ];

F2 = [ F12 F42 F72; ...
       F22 F52 F82; ...
       F32 F62 F92 ];

f = det(a*F1+(1-a)*F2)
c = coeffs(f,a);

c(1) = collect(c(1), [F71 F72 F81 F82 F91 F92]);
c(2) = collect(c(2), [F71 F72 F81 F82 F91 F92]);
c(3) = collect(c(3), [F71 F72 F81 F82 F91 F92]);
c(4) = collect(c(4), [F71 F72 F81 F82 F91 F92]);

matlabFunction(c,'file',file_name);