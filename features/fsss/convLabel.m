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

function label= convLabel(labelFn, outImage, dsetname)
    if nargin<3, dsetname= 'parisculpt'; end
    if nargin<2, outImage= false; end
    
    getPaths;
    
    if strcmp(dsetname, 'parisculpt')
        
        labelFn= [parissculptAnnoPath, labelFn];
        
        % orig: 1: ignore, 2: flora, 3: building, 4:sky
        labelIm= imread(labelFn);
        % 0: ignore, 1: other (building etc), 2: flora, 3: sky
        
        newVal= [0, 2, 1, 3];
        
        assert( length(newVal) >= max(labelIm(:)) );
        
        h= size(labelIm,1);
        w= size(labelIm,2);
        
        labelIm= newVal(labelIm(:));
        
        if (outImage)
            
            label= zeros(h*w, 3);
            
            newColours= [0 0 0; 128 0 0; 0 128 0; 0 0 128];
            label= reshape( newColours( labelIm+1, : ), [h, w, 3] );
            
        else
            label= reshape(labelIm, [h, w]);
        end
    
    else
        assert(strcmp(dsetname, 'stbg'));
        
        labelFn= [stanfordBgAnnoPath, labelFn(1:(end-4)), '.regions.txt'];
        
        fid= fopen(labelFn, 'r');
        format= repmat('%d', 1, 1000);
        c= textscan(fid,format);
        h= length(c{1});
        fclose(fid);
        
        f= fopen(labelFn, 'r');
        label= textscan(f, '%d'); label= label{:};
        fclose(fid);
        
        w= size(label, 1) / h;
        label= relja_col( reshape( label, w, h )' ) +1;
        
        assert( max(label)<= 8 );
        assert( all( label>-1e-6) );
        label(label<1e-6)= 0;
        
        if (outImage)
            assert(0);
        else
            label= reshape( label, h, w );
        end
        
    end
    
end
