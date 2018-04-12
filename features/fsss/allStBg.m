%
% Author:
% 
% Relja Arandjelovic (relja@robots.ox.ac.uk)
% Visual Geometry Group,
% Department of Engineering Science
% University of Oxford
% 
% Copyright 2014, all rights reserved.
% 

setup;

trainDset= 'stbg';
dictFn= 'data/dicts_stbg.mat';
modelFn= 'data/model_stbg.mat';

alpha= 15;
beta= 30;
gridSize= 25;
lam= 50000;
confThr= 0.1;

if ~exist(dictFn)
    relja_display('-- Compute RootSIFT + colour dictionaries');
    [rsiftDict, colDict]= compDict(trainDset);
    save(dictFn, 'rsiftDict', 'colDict');
end

load(dictFn, 'rsiftDict', 'colDict');

if ~exist(modelFn)
    relja_display('-- Learn the SVM');
    [trainPatches, countsPerImage]= getTrainSoftFeats('stbg', rsiftDict, colDict, gridSize, alpha, beta);
    
    [bestC, bestB, testAcc, crossTrainImg, finalModel]= svmCross(trainPatches, countsPerImage, rsiftDict, colDict, 'stbg');
    
    save( modelFn, 'bestC', 'bestB', 'testAcc', 'crossTrainImg', 'finalModel', 'alpha', 'beta', 'gridSize');
end

test_stbg(modelFn, rsiftDict, colDict, gridSize, lam);
