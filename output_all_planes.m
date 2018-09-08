%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function output_all_planes(x,img,model_list)
for k = 1:numel(model_list)
    ind = find(~isnan(model_list(k).Gs));
    v = reshape(x(:,ind),3,[]);
    H = model_list(k).A;
    H(3,:) = transpose(model_list(k).l);
    cc = model_list(k).cc;
    q = model_list(k).q;
    output_one_plane(img.data,H,cc,q,v);
end