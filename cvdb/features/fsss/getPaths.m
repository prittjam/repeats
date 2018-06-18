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

% input databases images
oxfordPath= '~/Relja/Databases/OxfordBuildings/'; % this should contain subfolder oxc1 for Oxford5k images and potentially ox100k for the Oxford 100k images
stanfordBgPath= '~/Relja/Databases/StanfordBackground/images/';
parisPath= '~/Relja/Databases/paris/images/';
sculpturesPath= '~/Relja/Databases/Sculptures6k/images/';

% input annotations
parissculptAnnoPath= 'data/parissculpt360/';
stanfordBgAnnoPath= '~/Relja/Databases/StanfordBackground/labels/';

% (some) output locations
oxfordSoftSegPath= 'output/softseg/ox/';
parissculptSoftSegPath= 'output/softseg/parissculpt/';
stanfordBgSoftSegPath= 'output/softseg/stbg/';
