function [] = test_watershed(origImg)
[grayLabel, edgeLabel] = SEGM.get_watershed(origImg, 1);
rgbLabel = label2rgb(grayLabel);
figure, imshow(rgbLabel); title('Output using Watershed')

rgbLabel = label2rgb(edgeLabel, 'jet', 'k');
figure, imshow(rgbLabel); title('Output using Canny')