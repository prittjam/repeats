%
%  Copyright (c) 2018 James Pritts, Denys Rozumnyi, CTU in Prague
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts and Denys Rozumnyi
%
function [gmm,X] = mask_to_gmm(BW,img,k)
dimg = im2double(img);
BW3 =  permute(repmat(BW,[1 1 3]),[3 1 2]);
img3 = permute(dimg,[3 1 2]);
X = reshape(img3(find(BW3)),3,[]);

options = statset('MaxIter',1000);
gmm = gmdistribution.fit(X',k, ...
                         'CovType','full',...
                         'SharedCov',false, ...
                         'Options',options);