%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function output_all_planes(x,img,model_list,stats_list)
for k = 1:numel(model_list)
    ind = find(~isnan(model_list(k).Gs));
    v = reshape(x(:,ind),3,[]);
    H = stats_list.ransac(end).A;
    H(3,:) = transpose(stats_list(end).l);
    cc = model_list(k).cc;
    q = model_list(k).q;
    output_one_plane(img.data,H,cc,q,v);
end