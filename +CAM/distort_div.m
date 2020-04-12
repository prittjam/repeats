function v = distort_div(u,q,varargin)
    if abs(q) > 0
        A = CAM.make_norm_xform(varargin{:});

        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end

        v = A*v;

        xu = v(1,:);
        yu = v(2,:);
        v(1,:) = xu/2./(q*yu.^2+xu.^2*q).*(1-sqrt(1-4*q*yu.^2-4*xu.^2*q));
        v(2,:) = yu/2./(q*yu.^2+xu.^2*q).*(1-sqrt(1-4*q*yu.^2-4*xu.^2*q));

        v = A\v;

        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end