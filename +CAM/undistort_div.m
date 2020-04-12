%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = undistort_div(u, q)
    if abs(q) > 0
        m = size(u,1);
        if (m == 2)
            u = [u;ones(1,size(u,2))];
        end

        v = A*u;
        dv = 1+q*(v(1,:).^2+v(2,:).^2);
        v(1:2,:)  = bsxfun(@rdivide,v(1:2,:),dv); 

        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end
