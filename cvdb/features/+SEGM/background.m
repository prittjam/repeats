function [] = background(image)
[height, width, planes] = size(image);
rgb = reshape(image, height, width * planes);

imagesc(rgb);                   % visualize RGB planes
% colorbar('on');                 % display colorbar

r = image(:, :, 1);             % red channel
g = image(:, :, 2);             % green channel
b = image(:, :, 3);             % blue channel

threshold = 100;                % threshold value
imagesc(b < threshold);         % display the binarized image

blueness = double(b) - max(double(r), double(g));

imagesc(blueness);              % visualize RGB planes
% colorbar('on');                    % display colorbar

% apply thresholding to segment the foreground
mask = blueness < 45;
imagesc(mask);

% create a label image, where all pixels having the same value
% belong to the same object, example
% 1 1 0 1 1 0      1 1 0 2 2 0
% 0 1 0 0 0 0      0 1 0 0 0 0
% 0 0 0 1 1 0  ->  0 0 0 3 3 0
% 0 0 1 1 1 0      0 0 3 3 3 0
% 1 0 0 0 1 0      4 0 0 0 3 0
labels = bwlabel(mask);

% get the label at point (200, 200)
id = labels(200, 200);

% get the mask containing only the desired object
man = (labels == id);
imagesc(man);

