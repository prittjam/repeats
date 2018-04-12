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

function [fns, labelFns, numFns]= fnlist(dsetname)
    if nargin<1, dsetname= 'parisculpt'; end
    getPaths;
    
    if strcmp(dsetname, 'parisculpt')
        labelFns= textread('data/parisculpt_anno_list.txt', '%s');
        numFns= length(labelFns);
        fns= cell(numFns,1);
        for i=1:numFns
            fn= labelFns{i};
            if (strcmp(fn(1:5), 'paris'))
                fns{i}= [parisPath, fn(12:(end-3)), 'jpg'];
            else
                fns{i}= [sculpturesPath, fn(17:(end-3)), 'jpg'];
            end
        end
    else
        assert(strcmp(dsetname, 'stbg'));
        
        dirname= stanfordBgPath;
        fns= dir(dirname);
        assert( strcmp(fns(1).name, '.') && strcmp(fns(2).name, '..') );
        fns= fns(3:end);
        
        fns= {fns.name}';
        labelFns= fns;
        numFns= length(fns);
        for i=1:numFns
            fns{i}= [dirname, fns{i}];
        end
    end
end
