try
	gray = imread('~/src/gtrepeat/dggt/two_planes.jpg');
	gray = rgb2gray(gray);
catch
	gray = imread('cameraman.tif');
end
figure;
imshow(gray);

%% LSD detectors
% Create two LSD detectors with standard and no refinement.
lsd1 = LINE.LineSegmentDetector('Refine','Standard');
lsd2 = LINE.LineSegmentDetector('Refine','None');

%%
% Detect the lines both ways
tic, lines1 = lsd1.detect(gray); toc
tic, lines2 = lsd2.detect(gray); toc

%% Result 1
% Show found lines with standard refinement
drawnLines1 = lsd1.drawSegments(gray, lines1);
figure;
imshow(drawnLines1), title('Standard refinement')
snapnow

%% Result 2
% Show found lines with no refinement
drawnLines2 = lsd2.drawSegments(gray, lines2);
figure;
imshow(drawnLines2), title('No refinement')
snapnow

%% Compare
[h,w,~] = size(gray);
[comparison,mis_count] = lsd1.compareSegments([w,h], lines1, lines2);
imshow(comparison), title(sprintf('Mismatch = %d', mis_count))
snapnow
lsd1.delete;
lsd2.delete;
