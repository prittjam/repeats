%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function H = hg_2e(C)
    C1a = make_sym_3x3(C(1:6,1));
    C2a = make_sym_3x3(C(1:6,2));
    C1b = make_sym_3x3(C(7:12,1));
    C2b = make_sym_3x3(C(7:12,2));

    [v1 m1 m2 is_order s1] = calc_points(C1a, C2a);
    [v2 m3 m4 is_order s2] = calc_points(C1b, C2b);
    [ix,iy] = order_points(m1,m2,is_order);
    if (dot(s1,s2) > 0)
        st = 'ascend';
    else
        st = 'descend';
    end

    [ix2,iy2] = order_points(m3,m4,is_order,st);
    m1 = m1(:,ix);
    m2 = m2(:,iy);
    m3 = m3(:,ix2);
    m4 = m4(:,iy2);

    u = [m1 m2 v1; ...
         m3 m4 v2];

    H = estimate_hg(u);

%    subplot(1,2,1);
%    hold on;
%    plot(m1(1,:),m1(2,:),'y.');
%    plot(m2(1,:),m2(2,:),'y.');
%    plot(v1(1,:),v1(2,:),'b.');
%
%    for i = 1:size(m1,2)
%        text(m1(1,i), m1(2,i), sprintf('%d',i));
%    end
%
%    for i = (size(m1,2)+1):(size(m1,2)+size(m2,2))
%        text(m2(1,i-size(m1,2)), m2(2,i-size(m1,2)), sprintf('%d',i));
%    end    
%
%    j = 1;
%    for i=(size(m1,2)+size(m2,2)+1):(size(m1,2)+size(m2,2)+size(v1,2))
%        text(v1(1,j), v1(2,j), sprintf('%d',i));
%        j = j+1;
%    end
%    
%    hold off;
%
%    subplot(1,2,2);
%    hold on;
%    plot(m3(1,:),m3(2,:),'y.');
%    plot(m4(1,:),m4(2,:),'y.');
%    plot(v2(1,:),v2(2,:),'b.');
%    for i = 1:size(m3,2)
%        text(m3(1,i), m3(2,i), sprintf('%d',i));
%    end
%
%    for i = (size(m3,2)+1):(size(m3,2)+size(m4,2))
%        text(m4(1,i-size(m3,2)), m4(2,i-size(m3,2)), sprintf('%d',i));
%    end
%    j = 1;
%    for i=(size(m4,2)+size(m3,2)+1):(size(m4,2)+size(m3,2)+size(v1,2))
%        text(v2(1,j), v2(2,j), sprintf('%d',i));
%        j = j+1;
%    end
%    hold off;
%
%    subplot(1,2,1);
%    axis([min(u(1,:))-100 max(u(1,:))+100 min(u(2,:))-100 max(u(2,:))+100]);
%
%    subplot(1,2,2);
%    axis([min(u(4,:))-100 max(u(4,:))+100 min(u(5,:))-100 max(u(5,:))+100]);
%
   
function de = find_real_distinct_eigvals(ea)
    e = diag(ea);
    [aa, ix] = sort(e);
    ie = setdiff([1 2 3],find(imag(e(ix))));
    [a,b] = ndgrid(1:length(ie), ...
                   1:length(ie));
    D = reshape(abs(e(ix(ie(a(:))))-e(ix(ie(b(:))))) > 1e-5, length(ie), ...
                length(ie));
    D = D+diag(ones(1,length(ie)));
    [ia ib] = find(D < 1);
    if (isempty(ia))
        de = ix(ie);
    else
        de = setdiff(ix(ie), [ia(:);ib(:)]);
    end

function d = find_exterior_poles(C, v);
    d = find(dot(v,C*v,1) > 1e7*eps);

function L = calc_polars(C1, v)
    C = inv(C1);
    num_poles = size(v,2);
    L = zeros(6,num_poles);
    for i = 1:num_poles
        m = renormI(v(:,i));
        m1 = m(1);
        m2 = m(2);
        m3 = m(3);
        c11 = C(1,1);
        c12 = C(1,2);
        c13 = C(1,3);
        c21 = C(2,1);
        c22 = C(2,2);
        c23 = C(2,3);
        c31 = C(3,1);
        c32 = C(3,2);
        c33 = C(3,3);
        
        l11 = (-(m2*sqrt((-(2*c11*m2*m3) + c12*m1*m3 + c13*m1*m2 + c21* ...
                            m1*m3...
        - c23*m1^2 + c31*m1*m2 - c32*m1^2)^2 -...
                           4*(m2*(c11*m2 - c12*m1 - c21*m1) + c22*m1^2)*(m3*(c11*m3 -...
        c13*m1 - c31*m1) + c33*m1^2))) + c12*m1*m2*m3 - c13*m1*m2^2 +...
        c21*m1*m2*m3 -...
        2*c22*m1^2*m3 + c23*m1^2*m2 - c31*m1*m2^2 +...
        c32*m1^2*m2)/(2*m1*(m2*(c11*m2 - c12*m1 - c21*m1) + c22*m1^2));


        l21 = (1/(2*(m2*(c11*m2 - c12*m1 - c21*m1) + c22*m1^2)))*...
        (sqrt((-(2*c11*m2*m3) + c12*m1*m3 + c13*m1*m2 + c21*m1*m3 -...
        c23*m1^2 + c31*m1*m2 - c32*m1^2)^2 - 4*(m2*(c11*m2 - c12*m1 - c21* ...
                                                    m1)...
        + c22*m1^2)*...
              (m3*(c11*m3 - c13*m1 - c31*m1) + c33*m1^2)) - 2*c11*m2*m3 +...
        c12*m1*m3 + c13*m1*m2 + c21*m1*m3 - c23*m1^2 + c31*m1*m2 - c32* ...
            m1^2);
 
        l12 = (m2*sqrt((-(2*c11*m2*m3) + c12*m1*m3 + c13*m1*m2 + c21*m1* ...
                        m3...
        - c23*m1^2 + c31*m1*m2 - c32*m1^2)^2 -...
                       4*(m2*(c11*m2 - c12*m1 - c21*m1) + c22*m1^2)*(m3*(c11*m3 -...
        c13*m1 - c31*m1) + c33*m1^2)) + c12*m1*m2*m3 - c13*m1*m2^2 +...
        c21*m1*m2*m3 -...
        2*c22*m1^2*m3 + c23*m1^2*m2 - c31*m1*m2^2 +...
        c32*m1^2*m2)/(2*m1*(m2*(c11*m2 - c12*m1 - c21*m1) + c22*m1^2));
        

        l22 = (1/(2*(m2*(c11*m2 - c12*m1 - c21*m1) + c22*m1^2)))*...
        (-sqrt((-(2*c11*m2*m3) + c12*m1*m3 + c13*m1*m2 + c21*m1*m3 -...
        c23*m1^2 + c31*m1*m2 - c32*m1^2)^2 - 4*(m2*(c11*m2 - c12*m1 - c21* ...
                                                    m1)...
        + c22*m1^2)*...
               (m3*(c11*m3 - c13*m1 - c31*m1) + c33*m1^2)) - 2*c11*m2*m3 ...
         +...
        c12*m1*m3 + c13*m1*m2 + c21*m1*m3 - c23*m1^2 + c31*m1*m2 - c32*m1^2);

        L(:,i) = [l11 l21 1 l12 l22 1]';
    end

function [vd m1 m2 is_order s] = calc_points(C1a, C2a)
    Q1 = inv(C1a)*C2a;
    [v, e] = eig(Q1);

    de = find_real_distinct_eigvals(e);
    vd = renormI(v(:,de(find(abs(v(3,de)) > 1000*eps))));

    ep1 = find_exterior_poles(C1a, vd);
    ep2 = find_exterior_poles(C2a, vd);
    ep3 = intersect(ep1,ep2);

    ep1 = setdiff(ep1, ep3);
    ep2 = setdiff(ep2, ep3);

    dualC1a = inv(C1a);
    dualC2a = inv(C2a);
    is_order = 0;
    m1 = [];
    m2 = [];
    while ~isempty(ep3)
         l3 = calc_polars(C1a, vd(:, ep3));
         l4 = calc_polars(C2a, vd(:, ep3));
         m1 = cat(2, m1, renormI(dualC1a*reshape(l3,3,[])));
         m2 = cat(2, m2, renormI(dualC2a*reshape(l4,3,[]))); 
         
         D = sqdist(m1(1:2,:),m2(1:2,:));
         [x,i] = min(D(:));
         [i,j] = ind2sub(size(D),i);
         is_order = 1;
         s = cross(m1(:,i)-vd(:,ep3(1)), m2(:,j)-vd(:,ep3(1)));
         ep3 = setdiff(ep3, ep3(1));
    end
    
    if is_order == 1
         m = m1(:,i);
         m1(:,i) = m1(:,1);
         m1(:,1) = m;

         m = m2(:,j);
         m2(:,j) = m2(:,1);
         m2(:,1) = m; 
    end

    if (~isempty(ep1))
        ve1 = vd(:,ep1);
        l1 = calc_polars(C1a, ve1);
        m1 = cat(2, m1, renormI(dualC1a*reshape(l1,3,[])));
    end
    
    if (~isempty(ep2))
        ve2 = renormI(vd(:,ep2));
        l2 = calc_polars(C2a, ve2);
        m2 = cat(2, m2, renormI(dualC2a*reshape(l2,3,[]))); 
    end    

    epp = find_exterior_poles(C2a,m1);
    if ~isempty(epp)
        l11 = calc_polars(C2a, m1(:,epp));
        m1tt = renormI(dualC2a*reshape(l11,3,[]));
        m1 = cat(2, m1, m1tt);
    end

    epp = find_exterior_poles(C1a,m2);
    if ~isempty(epp)
        l22 = calc_polars(C1a, m2(:,epp));
        m2tt = renormI(dualC1a*reshape(l22,3,[]));
        m2 = cat(2, m2, m2tt); 
    end
%    [m1,m2,m3,m4] = add_points(C1a, C2a, C1b, C2b, ...
%                               m1(:,ix),m2(:,iy),m3(:,ix2), ...
%                               m4(:,iy2), is_order);
%

function [m1,m2,m3,m4]  = add_points(C1a, C2a, C1b, C2b, ...
                                     m1, m2, m3, m4, is_order)
    ep = find_exterior_poles(C1a, m2);    
    if ~isempty(ep)
        dualC1a = inv(C1a);
        dualC1b = inv(C1b);
        l1 = calc_polars(C1a, m2(:,ep(1)));
        l2 = calc_polars(C1b, m4(:,ep(1)));
        m1 = cat(2, m1, renormI(dualC1a*reshape(l1,3,[])));
        m3 = cat(2, m3, renormI(dualC1b*reshape(l2,3,[])));        
    else
        dualC2a = inv(C2a);    
        dualC2b = inv(C2b);
        ep = find_exterior_poles(C2a, m1);    
        l1 = calc_polars(C2a, m1(:,ep(1)));
        l2 = calc_polars(C2b, m3(:,ep(1)));
        m2 = cat(2, m2, renormI(dualC1b*reshape(l1,3,[])));
        m4 = cat(2, m4, renormI(dualC2b*reshape(l2,3,[])));
    end
    [ix,iy] = order_points(m1,m2, is_order);
    m1 = m1(:,ix);
    m2 = m2(:,iy);

    [ix,iy] = order_points(m3,m4,is_order);
    m3 = m3(:,ix);
    m4 = m4(:,iy);

function [ix, iy] = order_points(m1,m2, is_order, st)
    if nargin < 4
        st = 'ascend';
    end

   if is_order
        i = 1;
        j = 1;
    else
        D = sqdist(m1(1:2,:),m2(1:2,:));
        [x,i] = min(D(:));
        [i,j] = ind2sub(size(D),i);
    end

    m1_u = m1(1:2,:)-mean(m1(1:2,:),2)*ones(1,size(m1,2));
    m1_u = m1_u./([1 1]'*sqrt(sum(m1_u.^2,1)));
    phi = -atan2(m1_u(2,i), m1_u(1,i));
    Rz = [cos(phi) -sin(phi); ...
          sin(phi) cos(phi)];
    x = Rz*m1_u;
    theta = [atan2(x(2,1:end),x(1,1:end))];
    it = find(theta < 0);
    theta(it) = theta(it)+2*3.1415926535;
    if strcmp(st,'ascend')
        theta(1) = 0;
    else
        theta(1) = 2*3.14159;
    end

    [a,ix] = sort(theta, st);

    m2_u = m2(1:2,:)-mean(m2(1:2,:),2)*ones(1,size(m2,2));
    m2_u = m2_u./([1 1]'*sqrt(sum(m2_u.^2,1)));
    phi = -atan2(m2_u(2,j),m2_u(1,j));
    Rz = [cos(phi) -sin(phi); ...
          sin(phi) cos(phi)];
    x = Rz*m2_u;
    theta = [atan2(x(2,1:end),x(1,1:end))];
    it = find(theta < 0);
    theta(it) = theta(it)+2*3.1415926535;
    if strcmp(st,'ascend')
        theta(1) = 0;
    else
        theta(1) = 2*3.14159;
    end
    [a,iy] = sort(theta, st);