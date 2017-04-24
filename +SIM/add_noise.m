% Copyright (c) 2017 James Pritts
% 
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
