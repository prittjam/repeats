%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X] = vp_annotate_lines(img)
    h = imshow(img);
    hl = [];
    button = 'a';
    vp = 1;
    i = 0;
   
    x = zeros(1,2);
    y = zeros(1,2);   
    color = zeros(1,3);
    color(vp) = 0.75;
    
    X = cell(1,2);
    
    while (button ~= 'q')
        
        [xx yy button] = ginput(1);
        
        switch button
          case 'n'
            vp = vp+1;
            if vp > 3
                vp = 1;
            end
            color = zeros(1,3);
            color(vp) = 0.75;
            
          case 'd'
            if length(X{vp}) > 0
                X{vp} = X{vp}(:,1:end-1);
                delete(hl(end));
                hl = hl(1:end-1);
                refresh(gcf);
                disp('shit');
            end
          
          otherwise
            i = i+1;
            x(i) = xx;
            y(i) = yy;
        end
        
        if ~mod(i,2) && i > 0
            i = 0;
            hl = cat(1,hl,line(x, y, ...
                               'Color', color, ...
                               'LineWidth', 2));
            X{vp} = cat(2, X{vp}, ...
                        [x(1) y(1) 1 x(2) y(2) 1]');
        end
    end