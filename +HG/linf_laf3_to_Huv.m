classdef linf_laf1_to_Huv
    methods(Static)
        function H = estimate(u0,m,n,linf)
            num_lafs = size(u0,2);
            num_pts = 3*num_lafs;
            if nargin < 2
                m = 1;
                n = 0;
            end
            
            if nargin < 3
                n = zeros(size(m));
            end
            
            u = renormI(reshape(u0(1:9,:),3,[]));
            v = renormI(reshape(u0(10:18,:),3,[]));
            
            y = linf'*u;
            mn = [reshape([m;m;m],[],1) reshape([n;n;n],[],1)];

            M = zeros(2*num_pts,6);

            y = sum(bsxfun(@times,u(1:3,:),linf))';
            zes = zeros(num_pts,1);

            ind1 = 2*(0:num_pts-1)+1;
            ind2 = 2*(1:num_pts);
            
            M(ind1,1:3) = [m.*y zes -u(1,:)'.*m.*y]; 
            M(ind2,1:3) = [zes m.*y -u(2,:)'.*m.*y]; 

            M(ind1,4:6) = [n.*y zes -u(1,:)'.*n.*y]; 
            M(ind2,4:6) = [zes n.*y -u(2,:)'.*n.*y]; 
            
            B = reshape(v(1:2,:)-u(1:2,:),[],1);
            
            c1 = find_perp(linf);
            c2 = cross(c1,linf);
            
            MM = [c1  c2  zeros(3,2); ...
                  zeros(3,2) c1 c2];
            
            uv = (M*MM)\B;
            
            uv2 = reshape(uv,2,[]);
            sx2 = sum(abs(uv2));
            isze = (sx2 == 0)
            if any(isze)
                M2 = [eye(3) eye(3); zeros(3,3) [0 -linf(3) linf(2); ...
                                    linf(3) 0 -linf(1); ...
                                    -linf(2) linf(1) 0]];
                b2 = [[[c1 c2]*uv2(:,~isze)];zeros(3,1)]
                
                uv = reshape((M2*MM)\B,2,[]);
                
                tst = [[c1 c2]*uv]
            end
            
            kkk = 3;
        end
    end
end

function v_perp = find_perp(v_input)
%FIND_PERP Finds one of the infinitely number of perpendicular vectors of
%   the input. The input vector v_input is a size 3,1 or 3,1 vector (only
%   3-dim supported)
    
    if length(v_input) ~= 3     % Can't be wrong dim if len=3
        error('find_perp:WrongSize','Input vector has wrong size');
    end
    
    if sum(v_input ~= 0) == 0
        error('find_perp:GivenZeroVector','Zero vector given as input');
    end
    
    v_perp = zeros(size(v_input));
    
    if sum(v_input ~= 0) == 3       % Every element is not-zero
        v_perp(1) = 1;
        v_perp(3) = -v_input(1)/(v_input(3));
    elseif sum(v_input ~= 0) == 2
        if v_input(1) == 0
            v_perp(1:2) = [1 1];
            v_perp(3) = -v_input(2)/(v_input(3));
        elseif v_input(2) == 0
            v_perp(1:2) = [1 1];
            v_perp(3) = -v_input(1)/(v_input(3));
        else
            v_perp(2:3) = [1 1];
            v_perp(1) = -v_input(2)/(v_input(1));
        end
    else
        if v_input(1) ~= 0
            v_perp(2) = 1;
        else
            v_perp(1) = 1;
        end
    end
    
    if abs(dot(v_perp,v_input)) > 1E-09      % Must take round-off into account (the dot product is not always perfect zero)
        error('find_perp:DotProdNotZero',...
            'A perp vector could not be found (failed dot product test). Might there be a bug?');
    end
end


                

