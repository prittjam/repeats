function v = undistort_kb(u, k, varargin)
    if any(k) > 0
        A = CAM.make_norm_xform(varargin{:});
        m = size(u,1);

        if (m == 2)
            u = [u;ones(1,size(u,2))];
        end

        v = A * u;
        
        theta_d = vecnorm(v(1:2,:),2,1);
        theta_d = min(max(-pi/2.0, theta_d), pi/2.0);
        sc = ones(1,size(theta_d,2));
        continue_flag = theta_d > 1e-15;
        theta = theta_d;
        for k1=1:10
            ind = find(continue_flag);
            theta_ = theta(ind);
            theta_d_ = theta_d(ind);
            k0_theta2 = k(1) .* theta_.^2;
            k1_theta4 = k(2) .* theta_.^4;
            k2_theta6 = k(3) .* theta_.^6;
            k3_theta8 = k(4) .* theta_.^8;
            theta_fix(ind) = (theta_ .* (1 + k0_theta2 +...
                                    k1_theta4 + k2_theta6 +...
                                    k3_theta8) - theta_d_) ./...
                        (1 + 3 .* k0_theta2 + 5 .* k1_theta4 +...
                                7 .* k2_theta6 + 9 .* k3_theta8);
            theta = theta - theta_fix;
            continue_flag = (abs(theta_fix) > 1e-15);
            if (sum(continue_flag) == 0)
                break;
            end
            sc = tan(theta) ./ theta_d;
        end
        
        v(1:2,:) = v(1:2,:) .* sc;
        v = A \ v;

        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end