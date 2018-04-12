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

function [rsiftDict, colDict]= compDict(dsetname)
    isStanfordBg= (strcmp(dsetname, 'stbg')==1);
    
    [fns, labelFns, numFns]= fnlist(dsetname);
    
    relja_display('Get dict');
    
    allHSV= [];
    allRSifts= [];
    
    tic
    rand('seed', 43);
    trainFns= randsample(fns, 100);
    for i= 1:length(trainFns)
        if i<5 || rem(i,20)==0, relja_display('%d / %d', i, length(trainFns)); end
        
        % image
        imRGB= imreadResize(trainFns{i});
        
        if isStanfordBg
            % images are small so reduce the sizes of dense SIFTs (default: 4,6,8,10)
            [imHSV, ~, rsifts]= allfeatures(imRGB, [4,6]);
        else
            [imHSV, ~, rsifts]= allfeatures(imRGB);
        end
        
        allHSV= [allHSV, imHSV( randsample(size(imHSV,1),500), : )'];
        allRSifts= [allRSifts, rsifts( :, randsample(size(rsifts,2),500) ) ];
    end
    clear rsifts im imHSV
    toc
    
    
    
    kRSift= 256;
    if isStanfordBg
        kCol= 128;
    else
        kCol= 256;
    end
    tic
    relja_display('Compute RootSIFT dict');
    rsiftDict= yael_kmeans( allRSifts, kRSift, 'seed', 43, 'verbose', 0);
    clear allRSifts;
    relja_display('Compute colour dict');
    colDict= yael_kmeans( allHSV, kCol, 'seed', 43, 'verbose', 0);
    clear allHSV;
    toc
end
