classdef linf_from_3laf
    methods(Static)
        function H = estimate(u,rsc)
            X = u(1:2,:);

            tx = mean(X(1,:));
            ty = mean(X(2,:));
            X(1,:) = X(1,:) - tx;
            X(2,:) = X(2,:) - ty;
            dsc = max(abs(X(:)));

            X = X / dsc;

            A = eye(3);
            A([1,2],3) = -[tx ty] / dsc;
            A(1,1) = 1 / dsc;
            A(2,2) = 1 / dsc;

            sc_norm = min(abs(rsc));

            Z = [X(1,:); X(2,:); -sc_norm./rsc(:)']';

            hs = pinv(Z) * -ones(size(X,2),1);

            H = eye(3);

            H(3,1) = hs(1);
            H(3,2) = hs(2);

            H = H * A;
        end

        function is_degen = is_sample_degen(u)
            du = u(1:2,[1 2 3])-u(1:2,[2 3 1]);
            du = bsxfun(@rdivide,du(1:2,:),sqrt(sum(du(1:2,:).^2,1)));
            du2 = du(:,[2 3 1]);
            angle = acos(dot(du,du2));
            ind = angle > pi/2;
            angle(ind) = pi-angle(ind);
            is_degen = all(angle < 15*pi/180);
        end

        function is_degen = is_model_degen(u,H)
            %detH = l(3)-l(1)-l(2);
            %is_degen = any((l'*v)/detH <= 0);
            v = renormI(H*u);
            is_degen = any(v(3,:)/v(3,1) <= 0);
        end
    end
end