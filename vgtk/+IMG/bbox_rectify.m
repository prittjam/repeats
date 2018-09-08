%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = bbox_rectify(bbox)
if nargin < 2
   bbox = []; 
end
repeats_init();
[name,pth] = uigetfile({'*.mat'}, ...
                       'FileSelector');
load([pth name]); 
[~,base_name] = fileparts(name); 
figure;
imshow(img);

bbox_file_name = [pth base_name '_bbox.mat'];
if (exist(bbox_file_name,'file') == 2)
    load(bbox_file_name)
end

if isempty(bbox)
    bbox = ginput(4);
    nx = size(img,2);
    ny = size(img,1);

    bbox(find(bbox(:,1) < 0.5),1) = 0.5;
    bbox(find(bbox(:,2) < 0.5),2) = 0.5;
    bbox(find(bbox(:,1) > nx+0.5),1) = nx+0.5;
    bbox(find(bbox(:,2) > ny+0.5),2) = ny+0.5;
end
    
k2 = 1;
MM = model_list(k2);
MM.H = model_list(k2).A;
MM.H(3,:) = transpose(model_list(k2).l);
rimg = IMG.render_rectification(x,MM,img, ...
                                'Registration','none', ...
                                'extents',...
                                [size(img,2) size(img,1)]', ...
                                'bbox',bbox);
figure;
imshow(rimg);
imwrite(rimg, [ pth  name '_rect.jpg']);
save([pth  base_name '_bbox.mat'],'bbox');
