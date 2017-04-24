% Copyright (c) 2017 James Pritts
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
function pts = distort(pts,cam,lambda)
u = [pts(:).u];
N = size(u,2);
if (lambda ~= 0)
    ud = CAM.rd_div(u,cam.cc,lambda);
else
    ud = u;
end

tmp = mat2cell(ud,3,ones(1,N));
[pts(:).ud] = tmp{:};
