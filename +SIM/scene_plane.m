classdef scene_plane
    properties
        X
    end

    methods
        function this = scene_plane(h,w,varargin)
            this.X = [0 w w 0; 0 0 h h; 0 0 0 0; 1 1 1 1];
        end            
    end
end
