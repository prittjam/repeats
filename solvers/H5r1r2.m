%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
% Created by Zuzana Kukelova 31.7.2014

%  H + r1 + r2 solver which first distort points using division model
%         [x]                     [H11+H12+H13][u]
%     a_i [y]              =      [H21+H22+H23][v]
%         [1+k1*(x^2+y^2)]        [H31+H32*H33][1+k2*(u^2+v^2)]
%
%  input  x - 5x2 matrix of 2D distorted measuremants
%         u - 5x2 matrix of 2D distorted measuremants
%


% 31.07.2013 - Kukelova


function [H k1 k2] = H5r(x, u)

H{1} = 10000*rand(3,3);
k1{1} = 10000;
k2{1} = 10000;

% last row of matrix equation
%  x_x*H*u_x = 0
% [ 0  1-k1*(x^2+y^2)   y]    [H11*u+H12*v+H13*(1+k2*(u^2+v^2))]
% [1+k1*(x^2+y^2)   0  -x] *  [H21*u+H22*v+H23*(1+k2*(u^2+v^2))]  = 0
% [-y   x              0]    [H31*u+H32*v+H33*(1+k2*(u^2+v^2))]
%
% last row:
% -y*(H11*u+H12*v+H13*(1+k2*(u^2+v^2)) + x*(H21*u+H22*v+H23*(1+k2*(u^2+v^2)) = 0

% columns correspond to [H11 H12 H13 H21 H22 H23 k2*H13 k2*H23]

M = [-x(1:5,2).*u(1:5,1),  -x(1:5,2).*u(1:5,2), -x(1:5,2)...
    x(1:5,1).*u(1:5,1),   x(1:5,1).*u(1:5,2),  x(1:5,1)...
    -x(1:5,2).*(u(1:5,1).^2+u(1:5,2).^2), x(1:5,1).*(u(1:5,1).^2+u(1:5,2).^2)];

% 3-dimensional null space
n = null(M);

% Parametrize [H11 H12 H13 H21 H22 H23 k2*H13 k2*H23] with 2 unknowns
% a*n(:,1)+b*n(:,2)+n(:,3)

   
    
% use second row of matrix equation  x_x*H*u=0
% to find solutions to H31,H32,H33, k1 k2 a b
    
% second row has the form
% (1+k1*(x^2+y^2))*(H11*u+H12*v+H13*(1+k2*(u^2+v^2)) - x*(H31*u+H32*v+H33*(1+k2*(u^2+v^2))= 0
% first row
% (-1-k1*(x^2+y^2))*(H21*u+H22*v+H23*(1+k2*(u^2+v^2)) +y*(H31*u+H32*v+H33*(1+k2*(u^2+v^2))= 0
    
% 5 equations from the second row   
% columns correspond to H31, H32, H33, k2*H33 k1*a, k1*b, k1, a, b, 1
% columns correspond to H31, H32, H33, k2*H33 k1*a, k2*a, a, k1*b, k2*b, k1, k2, b, 1
    
    
    
    
    M2 = [-x(:,1).*u(:,1),  -x(:,1).*u(:,2), -x(:,1), -x(:,1).*(u(:,1).^2+u(:,2).^2)...
     (x(:,1).^2+x(:,2).^2).*(n(1,1)*u(:,1)+n(2,1)*u(:,2)+n(3,1)*ones(5,1)+n(7,1)*(u(:,1).^2+u(:,2).^2))...
      zeros(5,1) ...
     (n(1,1)*u(:,1)+n(2,1)*u(:,2)+n(3,1)*ones(5,1)+n(7,1)*(u(:,1).^2+u(:,2).^2))...
     (x(:,1).^2+x(:,2).^2).*(n(1,2)*u(:,1)+n(2,2)*u(:,2)+n(3,2)*ones(5,1)+n(7,2)*(u(:,1).^2+u(:,2).^2))...
      zeros(5,1) ...
     (x(:,1).^2+x(:,2).^2).*(n(1,3)*u(:,1)+n(2,3)*u(:,2)+n(3,3)*ones(5,1)+n(7,3)*(u(:,1).^2+u(:,2).^2))...
    zeros(5,1) ...
    (n(1,2)*u(:,1)+n(2,2)*u(:,2)+n(3,2)*ones(5,1)+n(7,2)*(u(:,1).^2+u(:,2).^2))...
    (n(1,3)*u(:,1)+n(2,3)*u(:,2)+n(3,3)*ones(5,1)+n(7,3)*(u(:,1).^2+u(:,2).^2))...
        ];
    
    % equation a*n(7,1)+b*n(7,2)+n(7,3) - k2*(a*n(3,1)+b*n(3,2)+n(3,3)) = 0
    M2(6,:) = [ 0, 0, 0, 0, 0,  -n(3,1), n(7,1), 0, -n(3,2), 0, -n(3,3), n(7,2), n(7,3)]; 
    M2(7,:) = [ 0, 0, 0, 0, 0,  -n(6,1), n(8,1), 0, -n(6,2), 0, -n(6,3), n(8,2), n(8,3)];

    
    Mr = gj(M2);
    
    %[k1 k2 b] = H5r1r2_3var(Mr(3,8:13), Mr(4,8:13), Mr(5,8:13), Mr(6,8:13), Mr(7,8:13));
    [k1 k2 b] = H5r1r2_3var_c(Mr(3,8:13), Mr(4,8:13), Mr(5,8:13), Mr(6,8:13), Mr(7,8:13), Mr(3,11)/Mr(3,9) );
    
    for i = 1:size(k1,2)
        mon = [k1(i)*b(i) k2(i)*b(i) k1(i) k2(i) b(i) 1]';
        H{i}(3,1) = -Mr(1,8:13)*mon;
        H{i}(3,2) = -Mr(2,8:13)*mon;
        H{i}(3,3) = -Mr(3,8:13)*mon;
        a(i) = -Mr(7,8:13)*mon;
       
        H{i}(1,1) = a(i)*n(1,1) + b(i)*n(1,2) + n(1,3); 
        H{i}(1,2) = a(i)*n(2,1) + b(i)*n(2,2) + n(2,3);
        H{i}(1,3) = a(i)*n(3,1) + b(i)*n(3,2) + n(3,3);
        
        H{i}(2,1) = a(i)*n(4,1) + b(i)*n(4,2) + n(4,3); 
        H{i}(2,2) = a(i)*n(5,1) + b(i)*n(5,2) + n(5,3);
        H{i}(2,3) = a(i)*n(6,1) + b(i)*n(6,2) + n(6,3);
    end
    
    %test
    %[0 -1-k1(i)*(x(j,1)^2 + x(j,2)^2) x(j,2); 1+k1(i)*(x(j,1)^2 + x(j,2)^2) 0 -x(j,1); -x(j,2) x(j,1) 0 ]*H{i}*[u(j,1) u(j,2) 1+k2(i)*(u(j,1)^2 + u(j,2)^2)]'
    end


