% Copyright (c) 2017 James Pritts
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
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
