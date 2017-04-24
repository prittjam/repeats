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
function pts = add_noise(pts,ccd_sigma)
ud = [pts(:).ud];
N = size(ud,2);
if (ccd_sigma > 0)
    udn = ud+[normrnd(0,ccd_sigma,[2 N]); ...
              zeros(1,N)];
else 
    udn = ud;
end

tmp = mat2cell(udn,3,ones(1,N));
[pts(:).udn] = tmp{:};
