%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
% James Pritts, 10/31/2010
% Czech Technical University
% The Center for Machine Perception
% http://cmp.felk.cvut.cz/
% 
% Permission is hereby  granted, free of charge, to any  person obtaining a copy
% of this software and associated  documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% The software is provided "as is", without warranty of any kind.

function hg_pole_polar_test()
    nn = [640;480];
    fc = [50 50];
    alpha_c = 0;
    Rccs = [ 0   1   0;
             0   0  -1;
             -1   0   0]; 
    mean_dist_coa = 20;
    std_dist_coa = 5;
    dist_to_coa = std_dist_coa*randn(2,1)+mean_dist_coa;

    center_of_attention = [0 0 0]';

    C1 = make_random_rotation()*[0 10*dist_to_coa(1) 0]';
    C2 = make_random_rotation()*[0 10*dist_to_coa(2) 0]';
    P1 = make_affine_camera(fc,alpha_c,Rccs,C1,center_of_attention);
    P2 = make_affine_camera(fc,alpha_c,Rccs,C2,center_of_attention+[2 2 2]');

    [Fa_truth] = faff_two_cameras(P1,P2);
    Fa_truth = Fa_truth./Fa_truth(3,3);

    X = make_3d_point_list(5,center_of_attention,4);
    X(3,:) = 0;
    dc = [7 7 7]'.*(rand(3,1)-0.5);    
    [C M R t] = make_coplanar_ellipses(2*randn(1)+3,+2*randn(1)+3, ...
                                   2*randn(1)+3,+2*randn(1)+3, ...
                                   center_of_attention+dc); 
    X = R*X(1:3,:)+t*ones(1,size(X,2));
    X = [X;ones(1,size(X,2))];
    x1 = renormI(P1*X);
    x2 = renormI(P2*X);

    M = cat(3, M, M);

    figure;
    hold on;
    draw_affine_camera_list(cat(3,P1,P2), ...
                            [C1 C2], repmat(nn,[1 ...
                        2]));
    plot3(X(1,:),X(2,:),X(3,:),'ro');
    draw_3d_ellipse_list(C, M);
    hold off;
    
    CCa = project_3d_ellipse(P1,C,M);
    CCb = project_3d_ellipse(P2,C,M);
 
    cameratoolbar;
    axis equal;
    axis vis3d;
    xlabel('X')
    ylabel('Y');
    zlabel('Z');
    grid on;

    figure;

    subplot(1,2,1);
    draw_ellipse_list(CCa);
    axis equal;
    axis ij;
    
    subplot(1,2,2);
    draw_ellipse_list(CCb);
    axis equal;
    axis ij;
    
    H = hg_2e([CCa;CCb]);

    subplot(1,2,1);
    hold on;
    plot(x1(1,:),x1(2,:), 'g.');
    hold off;

    subplot(1,2,2);
    hold on;
    plot(x2(1,:),x2(2,:), 'g.');

    u2 = renormI(H*x1(1:3,:));
    plot(u2(1,:),u2(2,:),'r.');
    hold off;