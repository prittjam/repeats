classdef linf_from_2x2laf
    properties

    end
    
    methods(Static)
        function H = estimate(aX,arsc)
        % scale2H_multi
            if ~iscell(aX)
                aX = {aX};
                arsc = {arsc};
            end
            
            ALLX = [aX{:}];
            ALLX = ALLX(1:2,:);
            
            tx = mean(ALLX(1,:));
            ty = mean(ALLX(2,:));
            ALLX(1,:) = ALLX(1,:) - tx;
            ALLX(2,:) = ALLX(2,:) - ty;
            dsc = max(abs(ALLX(:)));
            
            A = eye(3);
            A([1,2],3) = -[tx ty] / dsc;
            A(1,1) = 1 / dsc;
            A(2,2) = 1 / dsc;
            
            len = length(aX);
            Z = [];
            R = [];

            for i = 1:len
                X = aX{i};
                rsc = arsc{i};
                X(1,:) = (X(1,:) - tx) / dsc;
                X(2,:) = (X(2,:) - ty) / dsc;
                
                z = [rsc .* X(1,:); rsc .* X(2,:)];
                z(len+2, :) = 0;
                z(i+2,:) = -ones(1, size(X,2));
                
                Z = [Z; z'];
                R = [R; rsc(:)];
            end
            
            hs = pinv(Z) * -R;
            
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