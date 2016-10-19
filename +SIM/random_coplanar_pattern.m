classdef random_coplanar_pattern < SIM.coplanar_pattern
    properties
        params;
    end
    
    methods
        function this = random_coplanar_pattern(sp,varargin)            
            params = [5 5; ...    % template height [h2]
                      5 5; ...    % template width  [w2]
                      3 3; ...   % number of instance rows
                      3 3; ...  % number of instance columns           
                      5 5];  % number of lafs in template [nlafs];
            params(5,2) = params(5,2)+1-eps;
            
            rv = params(:,1)+(params(:,2)-params(:,1)).*rand(size(params,1),1);

            maxr = floor(sp.h/rv(1));
            maxc = floor(sp.w/rv(2));

            rv([3 4 5]) = floor(rv([3 4 5]));
            
            h2 = rv(1);
            w2 = rv(2);
            num_rows = rv(3);
            num_cols = rv(4);
            num_lafs = rv(5);
            
            dx = (sp.w-rv(4)*rv(4))/rv(4);
            dy = (sp.h-rv(3)*rv(3))/rv(3);
            
            this@SIM.coplanar_pattern(w2,h2,dx,dy, ...
                                      num_lafs,num_rows, ...
                                      num_cols,varargin);
        end
    end
end