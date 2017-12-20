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

function eg_faff_two_ellipses()
nn = [640;480];
fc = [50 50];
alpha_c = 0;
Rccs = [0   1   0;
        0   0  -1;
       -1   0   0]; 
mean_dist_coa = 20;
std_dist_coa = 5;
dist_to_coa = std_dist_coa*randn(2,1)+mean_dist_coa;

center_of_attention = [0 0 0]';

C1 = make_random_rotation()*[0 dist_to_coa(1) 0]';
C2 = make_random_rotation()*[0 dist_to_coa(2) 0]';
P1 = make_affine_camera(fc,alpha_c,Rccs,C1,center_of_attention);
P2 = make_affine_camera(fc,alpha_c,Rccs,C2,center_of_attention+[2 2 2]');

[Fa_truth] = faff_two_cameras(P1,P2);
Fa_truth = Fa_truth./Fa_truth(3,3);

[CCw MM] = make_3d_ellipse_list(15,center_of_attention);
[X] = make_3d_point_list(15,center_of_attention,4);

x1 = renormI(P1*X);
x2 = renormI(P2*X);

figure;
draw_affine_camera_list(cat(3,P1,P2), [C1 C2], repmat(nn,[1 2]));
draw_3d_ellipse_list(CCw,MM);
hold on;
plot3(X(1,:)',X(2,:)',X(3,:)','r.');
hold off;

cameratoolbar;
axis equal;
axis vis3d;
xlabel('X')
ylabel('Y');
zlabel('Z');
grid on;

CC_1 = project_3d_ellipse(P1,CCw,MM);
CC_2 = project_3d_ellipse(P2,CCw,MM);

figure;

subplot(3,2,1);
draw_ellipse_list(CC_1);
hold on; plot(x1(1,:),x1(2,:),'r.');hold off;
axis equal;
axis ij;
axis([-(nn(1)-1)/2 (nn(1)-1)/2 -(nn(2)-1)/2 (nn(2)-1)/2]); 

subplot(3,2,2);
draw_ellipse_list(CC_2);
hold on; plot(x2(1,:),x2(2,:),'r.');hold off;
axis equal;
axis ij;
axis([-(nn(1)-1)/2 (nn(1)-1)/2 -(nn(2)-1)/2 (nn(2)-1)/2]);

subplot(3,2,3);
draw_epipolar_lines(x2,Fa_truth');
hold on;
plot(x1(1,:),x1(2,:),'r.');
hold off;
axis ij;
axis([-(nn(1)-1)/2 (nn(1)-1)/2 -(nn(2)-1)/2 (nn(2)-1)/2]); 

subplot(3,2,4);
draw_epipolar_lines(x1,Fa_truth);
hold on;
plot(x2(1,:),x2(2,:),'r.');
hold off;
axis ij;
axis([-(nn(1)-1)/2 (nn(1)-1)/2 -(nn(2)-1)/2 (nn(2)-1)/2]); 

cspnd = 1:size(CCw,3);

ia = [1 2];

fittingfn = @faff_two_ellipses;
distfn = @faff_gs_distfn;
degenfn = @faff_test_degen;
feedback = 1;
num_samples = 2;
max_trials = 100000;
degen_trials = 100;

u = zeros(18,size(CC_1,3));
for i = 1:size(CC_1,3)
    u(:,i) = laf_from_ellipse_pair(CC_1(:,:,i),CC_2(:,:,i))';
end

[Fa, inl, stats] = ransac_faff_two_ellipse(u, 1, 0.95);  

subplot(3,2,5);
draw_epipolar_lines(x2,Fa');
hold on;
plot(x1(1,:),x1(2,:),'r.');
hold off;
axis ij;
axis([-(nn(1)-1)/2 (nn(1)-1)/2 -(nn(2)-1)/2 (nn(2)-1)/2]); 

subplot(3,2,6);
draw_epipolar_lines(x1,Fa);
hold on;
plot(x2(1,:),x2(2,:),'r.');
hold off;
axis ij;
axis([-(nn(1)-1)/2 (nn(1)-1)/2 -(nn(2)-1)/2 (nn(2)-1)/2]); 
end