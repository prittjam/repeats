classdef scene_plane
    properties
        w,h;
        X,M,M0;
        model_xform;
    end

    methods
        function this = scene_plane(w,h,varargin)
            this.w = w;
            this.h = h;
                        
            g = [0 0 -1]'; % gravity direction
            z2 = [1 0 0]';
            x2 = cross(z2,g);
            y2 = cross(z2,x2);

            M1 = [1  0 -w/2; ...
                  0 -1  h/2; ...
                  0  0    0; ...
                  0  0    1];  
            this.M0 = [ [x2 y2 z2] [0 0 h/2]'; ...
                        [0 0 0 1] ];

            this.model_xform = this.M0*M1;            
            this.X = this.model_xform*[[0 0; w 0; w h; 0 h]';ones(1,4)];
            this.M = inv(this.M0);
        end            
        
        
    end
end