%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef pt2x2_to_lu 
    properties
        A = [];
        invA = [];
        normcc;
        cc = [];
    end

    methods(Static)
        function M = solve(x)
            l1 = cross(x(1:3,1),x(4:6,1));
            l2 = cross(x(1:3,2),x(4:6,2));
            l3 = cross(x(1:3,1),x(1:3,2));
            l4 = cross(x(4:6,1),x(4:6,2));

            u = cross(l1,l2);
            w = cross(l3,l4);
            
            l = cross(u,w);
            %            l = A'*l;
            u = pt1x2l_to_u(x,l);
            M = struct('l', l, 'u', u, ...
                       'solver_time',0, ...
                       'Hu',eye(3)+u*l', ...
                       'q', 0);
        end
    end
        
    methods
        function this = pt2x2_to_lu()
        end
        
        function M = fit(this,x,idx,varargin)
            x = x(:,[idx{:}]);
            x6 = reshape(x,6,[]);
            M = WRAP.pt2x2_to_lu.solve(x6);            
        end

    end
end
