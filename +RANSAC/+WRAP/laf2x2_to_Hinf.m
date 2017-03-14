% Copyright (c) 2017 James Pritts, Denys Rozumnyi
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
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
classdef laf2x2_to_Hinf
    properties
        mcs = 2;
        mss = 2;
    end
        
    methods
        function this = laf2x2_to_Hinf_model(labeling)
        end
        
        function M = fit(this,dr,labeling)
            u = [dr(G>0).u];
            G = findgroups(G(G > 0));
            M = { HG.laf2x2_to_Hinf(u,G) };
        end
        
        function flag = is_sample_good(this,dr,labeling)
            u = [dr(labeling > 0).u];
            flag = not(LAF.are_colinear(u));
        end            

        function flag = is_model_good(this,dr,labeling,M) 
            flag = false(1,numel(M));
            for k = 1:numel(M)
                u = cmp_splitapply(@(x)({dr.u}),dr,labeling);
                H = M{k};
                l = H(3,:)';
                flag = PT.are_same_orientation(u,l); 
            end
        end               
    end
end
