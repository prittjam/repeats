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
classdef laf2x2_to_HaHp
    properties
        mcs = 2;
        mss = 2;
    end
    
    methods
        function this = laf2x2_to_HaHp()
        end

        function M = fit(this,dr,corresp,idx)            
            m  = reshape(corresp(:,idx),1,[]);

            x = [dr(m).u];
            G = findgroups([dr(m).Gapp]);

            Hp = HG.laf2x2_to_Hinf(x,G);
            xp = LAF.renormI(blkdiag(Hp,Hp,Hp)*x);
            Ha = HG.laf2x1_to_Amu(xp,G);

            if ~isempty(Ha)
                M = { Ha*Hp } ;
            else
                M  = { Hp };
            end
        end

        function is_good = is_sample_good(this,dr,corresp,idx)
            m  = reshape(corresp(:,idx),1,[]);
            x = [dr(m).u];
            is_good = not(LAF.are_colinear(x));
        end    

        function is_good = is_model_good(this,dr,corresp,idx,M) 
            m  = reshape(corresp(:,idx),1,[]);
            x = [dr(m).u]; 
            is_good = LAF.are_same_orientation(x,M(3,:)'); 
        end        
        
        function M = fix(this,dr,corresp,idx,model)
            M = [];
        end
    end
end 
