% Copyright (c) 2017 James Pritts
% 
classdef random_scene_plane < SIM.scene_plane
    properties
    end
    
    methods
        function this = random_scene_plane()
            dims = rand(1,2).*[40 40]+30;
            this@SIM.scene_plane(dims(1),dims(2));
        end
    end
end
