%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
% Copyright (c) 2017 James Pritts
% 
classdef random_coplanar_pattern < GRID.coplanar_pattern
    properties
        border = [];
        w = [];
        h = [];
    end
    
    methods
        function this = random_coplanar_pattern()            
            dims = rand(1,2).*[40 40]+30;
            h = dims(1);
            w = dims(2);
            
            params = [4 8; ...   % number of instance rows
                      4 8; ...  % number of instance columns           
                      2 2];  % number of lafs in template [nlafs];
            
            rv = params(:,1)+round((params(:,2)-params(:,1)).*rand(3,1));
            
            num_rows = rv(1);
            num_cols = rv(2);
            
            dx = w/num_cols;
            dy = h/num_rows;
            
            w2 = (0.5*rand(1)+0.3)*dx;
            h2 = (0.5*rand(1)+0.3)*dy;
            
            num_lafs = rv(3);
            
            this@GRID.coplanar_pattern(w2,h2,dx,dy, ...
                                      num_lafs,num_rows,num_cols);
            this.border = [0 w w 0; 0 0 h h; 0 0 0 0; 1 1 1 1];            
            this.h = dims(1);            
            this.w = dims(2);
        end
    end
end
