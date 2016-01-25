function [grayLabel, edgeLabel] = get_watershed(origImg, flag)
% convert to grayscale
img = rgb2gray(origImg);

% create an appropriate structuring element
w_size = 20;
seSquare = strel('square', w_size);

% opening by reconstruction - to smooth dark regions
imgEroded = imerode(img, seSquare);
imgRecon = imreconstruct(imgEroded, img);

% invert and repeat - to smooth bright regions
imgReconComp = imcomplement(imgRecon);
imgEroded2 = imerode(imgReconComp, seSquare);
imgRecon2 = imreconstruct(imgEroded2, imgReconComp);

% get foreground markers
fgm = imregionalmax(imgRecon2);

% get background markers - this step can be skipped 
% in which case only fgm would be the marker image 
% and the segmentation would be different 
distTrans = bwdist(fgm);
wLines= watershed(distTrans);
bgm = wLines == 0;

% get the segmentation function and impose markers
% perform watershed segmentation
seSquare3 = strel('square', 3);
rangeImg = rangefilt(imgRecon2, getnhood(seSquare3));
segFunc = imimposemin(rangeImg, fgm | bgm);
grayLabel = uint32(watershed(segFunc));

% alternatively, extract edges from the preprocessed image
% perform morph cleanup
if nargin > 1
	bwEdges = edge(imgRecon2, 'canny');
	bwFilled = imfill(bwEdges, 'holes');
	bwRegions = imopen(bwFilled, seSquare3);
	edgeLabel = uint32(bwlabel(bwRegions));
end