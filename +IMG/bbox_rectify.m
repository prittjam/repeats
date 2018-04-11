function [] = bboxrect(bbox)
if nargin < 2
   bbox = []; 
end
greedy_repeats_init();
[name,pth] = uigetfile({'*.mat'}, ...
                       'FileSelector');
load([pth name]);
[~,base_name] = fileparts(name); 
figure;
imshow(img);

if isempty(bbox)
    border = ginput(4);
    nx = size(img,2);
    ny = size(img,1);

    border(find(border(:,1) < 0.5),1) = 0.5;
    border(find(border(:,2) < 0.5),2) = 0.5;
    border(find(border(:,1) > nx+0.5),1) = nx+0.5;
    border(find(border(:,2) > ny+0.5),2) = ny+0.5;
end
    
k2 = 1;
MM = model_list(k2);
MM.H = model_list(k2).A;
MM.H(3,:) = transpose(model_list(k2).l);
rimg = IMG.render_rectification(x,MM,img, ...
                                'Registration','none', ...
                                'extents',...
                                [size(img,2) size(img,1)]', ...
                                'bbox',border);
figure;
imshow(rimg);
imwrite(rimg, [ pth '/' name '_rect.jpg']);
save([pth '/' base_name '_bbox.mat']);
