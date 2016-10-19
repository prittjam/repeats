classdef random_scene_plane < SIM.scene_plane
    properties
    end
    
    methods
        function this = random_scene_plane(varargin)
            params = [60 90; ...  % scene plane height [h]
                      60 90];  % scene plane width [w]
            
            rv = params(:,1)+(params(:,2)-params(:,1)).*rand(2,1);                      
            h = rv(1);
            w = rv(2);
            
            this@SIM.scene_plane(w,h,varargin{:});
        end
    end
end