% The Software is provided "as is", without warranty of any kind.
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
classdef laf1x3_to_Hinf
    properties
        mss = 3;
    end
    
    methods
        function this = laf3x1_to_Hinf_model()
        end

        function M = fit(this,dr,G)
            u = [dr(G > 0).u];
            G = findgroups(G(G > 0));
            M = { HG.laf3x1_to_Hinf(u) };
        end

        function flag = is_sample_good(this,dr,labeling)
            u = [dr(labeling > 0).u];
            flag = not(LAF.are_colinear(u));
        end    

        function flag = is_model_degen(this,dr,labeling,M) 
            flag = false(1,numel(M));
            for k = 1:numel(M)
                u = splitapply(@(x)({dr.u}),dr,labeling);
                H = M{k};
                l = H(3,:)';
                flag = PT.are_same_orientation(u,l); 
            end
        end        
    end
end
