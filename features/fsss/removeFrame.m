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

function [imRGB, frameinfo]= removeFrame(imRGB)
    h= size(imRGB,1); w= size(imRGB,2);
    seedY= 3; seedX= 3; simThr= 0.1;
    edgeThr= 0.5; propEdgeThr= 0.1;
    
    if size(imRGB,3)==3
        frameDet= reshape( vl_alldist( reshape(imRGB,[],3)', squeeze(imRGB(seedY,seedX,:)) ) < simThr, h, w);
    else
        frameDet= reshape( (imRGB(:)-imRGB(seedY,seedX)).^2 < simThr, h, w);
    end
    
    horiz= all( frameDet( 1:round(h/10), round(w/10):(end-round(w/10)) ), 2);
    y1= find(horiz, 1, 'last');
    horiz= all( frameDet( round(9*h/10):end, round(w/10):(end-round(w/10)) ), 2);
    y2= find(horiz, 1, 'first') + round(9*h/10)-1;
    vert= all( frameDet( round(h/10):(end-round(h/10)), 1:round(w/10) ), 1);
    x1= find(vert, 1, 'last');
    vert= all( frameDet( round(h/10):(end-round(h/10)), round(9*w/10):end ), 1);
    x2= find(vert, 1, 'first') + round(9*w/10)-1;
    
    frameinfo= struct();
    frameinfo.origH= size(imRGB,1);
    frameinfo.origW= size(imRGB,2);
    
    if isempty(y1) || isempty(y2) || isempty(x1) || isempty(x2)
        frameinfo.hasFrame= false;
    else
        
        % check if there is an edge
        hy= fspecial('sobel');
        hx= hy';
        img= rgb2gray(imRGB);
        vert= abs(imfilter(img, hx));
        horiz= abs(imfilter(img, hy));
        
        hasEdge1= sum( horiz(y1,x1:x2) > edgeThr ) > propEdgeThr*(x2-x1+1);
        hasEdge2= sum( horiz(y2,x1:x2) > edgeThr ) > propEdgeThr*(x2-x1+1);
        hasEdge3= sum( vert(y1:y2,x1) > edgeThr ) > propEdgeThr*(y2-y1+1);
        hasEdge4= sum( vert(y1:y2,x2) > edgeThr ) > propEdgeThr*(y2-y1+1);
        
        if  hasEdge1+hasEdge2+hasEdge3+hasEdge4 > 1
            frameinfo.hasFrame= true;
            frameinfo.roi= [x1,x2,y1,y2];
            imRGB= imRGB( (y1+1):(y2-1), (x1+1):(x2-1), : );
        else
            frameinfo.hasFrame= false;
        end
    end
end
